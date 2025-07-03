
import Foundation
import SwiftData

/// Uygulamanın ana ViewModel'i. Görünümler (Views) ve Modeller (Models) arasındaki iş mantığını yönetir.
@MainActor
class HabitViewModel: ObservableObject {
    
    // MARK: - Properties
    
    /// SwiftData veritabanı ile etkileşim kurmak için kullanılan model context.
    private var modelContext: ModelContext
    
    /// Veritabanındaki tüm alışkanlıkları tutan ve değişiklikleri otomatik olarak yansıtan dizi.
    @Published var habits: [Habit] = []
    
    // MARK: - Initializer
    
    /// ViewModel'i belirtilen bir model context ile başlatır.
    /// - Parameter modelContext: SwiftData için kullanılacak olan model context.
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchHabits()
    }
    
    // MARK: - Data Fetching
    
    /// Veritabanından arşivlenmemiş tüm alışkanlıkları çeker ve `habits` dizisini günceller.
    func fetchHabits() {
        do {
            let descriptor = FetchDescriptor<Habit>(
                predicate: #Predicate { $0.isArchived == false },
                sortBy: [SortDescriptor(\Habit.creationDate, order: .reverse)]
            )
            habits = try modelContext.fetch(descriptor)
        } catch {
            print("Alışkanlıklar çekilirken hata oluştu: \(error.localizedDescription)")
        }
    }
    
    // MARK: - CRUD Operations (Create, Read, Update, Delete)
    
    /// Yeni bir alışkanlık oluşturur ve veritabanına ekler.
    /// - Parameters:
    ///   - name: Alışkanlığın adı.
    ///   - whyNote: Alışkanlığa başlama nedeni.
    func addHabit(name: String, whyNote: String) {
        let newHabit = Habit(name: name, whyNote: whyNote)
        modelContext.insert(newHabit)
        fetchHabits() // Listeyi güncelle
    }
    
    /// Belirtilen alışkanlığı veritabanından siler.
    /// - Parameter habit: Silinecek olan alışkanlık.
    func deleteHabit(_ habit: Habit) {
        modelContext.delete(habit)
        fetchHabits() // Listeyi güncelle
    }
    
    /// Belirtilen alışkanlığı arşivler.
    /// - Parameter habit: Arşivlenecek alışkanlık.
    func archiveHabit(_ habit: Habit) {
        habit.isArchived = true
        fetchHabits() // Ana listeden kaldır
    }
    
    /// Belirtilen alışkanlığı arşivden çıkarır.
    /// - Parameter habit: Arşivden çıkarılacak alışkanlık.
    func unarchiveHabit(_ habit: Habit) {
        habit.isArchived = false
        fetchHabits() // Ana listeye ekle
    }
    
    /// Bir alışkanlığın belirli bir tarihteki durumunu günceller (tamamlama, sıfırlama vb.).
    /// - Parameters:
    ///   - habit: İşlem yapılacak alışkanlık.
    ///   - date: İşlemin yapıldığı tarih.
    ///   - status: Yeni durum (tamamlandı, sıfırlandı vb.).
    ///   - resetNote: Eğer sıfırlama ise, sıfırlama notu.
    func logHabit(for habit: Habit, on date: Date, with status: LogStatus, resetNote: String? = nil) {
        // O tarihe ait bir log var mı diye kontrol et
        if let existingLog = habit.logs.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            // Eğer varsa, durumunu güncelle
            existingLog.status = status
            existingLog.resetNote = resetNote
        } else {
            // Eğer yoksa, yeni bir log oluştur
            let newLog = HabitLog(date: date, status: status, resetNote: resetNote)
            newLog.habit = habit
            modelContext.insert(newLog)
            habit.logs.append(newLog)
        }
        
        // Değişikliklerin kaydedilmesi için try? modelContext.save() gerekebilir, ancak SwiftData genellikle otomatik yapar.
        fetchHabits() // UI'ı güncellemek için
    }
    
    /// Bir alışkanlığı ve o güne ait tüm logları duraklatılmış olarak işaretler.
    /// - Parameters:
    ///   - habit: Duraklatılacak alışkanlık.
    ///   - date: Duraklatma işleminin yapıldığı tarih.
    func pauseHabit(_ habit: Habit, on date: Date) {
        logHabit(for: habit, on: date, with: .paused)
    }
    
    /// Bir alışkanlığın serisini sıfırlar ve nedenini bir not ile kaydeder.
    /// - Parameters:
    ///   - habit: Serisi sıfırlanacak alışkanlık.
    ///   - date: Sıfırlama işleminin yapıldığı tarih.
    ///   - note: Sıfırlama nedeni.
    func resetStreak(for habit: Habit, on date: Date, note: String) {
        logHabit(for: habit, on: date, with: .reset, resetNote: note)
    }
    
    // MARK: - Business Logic
    
    /// Bir alışkanlığın mevcut kesintisiz serisini (streak) hesaplar.
    /// - Parameter habit: Serisi hesaplanacak alışkanlık.
    /// - Returns: Gün cinsinden seri sayısı.
    func calculateStreak(for habit: Habit) -> Int {
        let sortedLogs = habit.logs
            .filter { $0.status == .completed }
            .sorted(by: { $0.date > $1.date })
        
        var streak = 0
        var currentDate = Date()
        
        // Bugün tamamlandı mı?
        if let lastLog = sortedLogs.first, Calendar.current.isDate(lastLog.date, inSameDayAs: currentDate) {
            streak += 1
            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        }
        
        // Geriye dönük sayım
        for log in sortedLogs.dropFirst() {
            if Calendar.current.isDate(log.date, inSameDayAs: currentDate) {
                streak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break // Seri bozuldu
            }
        }
        
        return streak
    }
    
    /// Bir serinin ulaştığı en son dönüm noktasını (milestone) döndürür.
    /// - Parameter streak: Kontrol edilecek seri sayısı.
    /// - Returns: Ulaşılan en son dönüm noktası (örn: 7, 30) veya hiçbiri ise nil.
    func checkMilestone(for streak: Int) -> Int? {
        let milestones = [365, 100, 30, 7]
        return milestones.first { streak >= $0 }
    }
    
    /// Belirli bir alışkanlık için son 30 gündeki tamamlama oranını hesaplar.
    /// - Parameter habit: Oranı hesaplanacak alışkanlık.
    /// - Returns: 0.0 ile 1.0 arasında bir oran değeri.
    func calculateMonthlyCompletionRate(for habit: Habit) -> Double {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        let recentLogs = habit.logs.filter { $0.date >= thirtyDaysAgo && $0.status == .completed }
        
        // Son 30 günde kaç gün hedeflendiğini bulmak daha karmaşık bir mantık gerektirir
        // (örn: haftanın belirli günleri). Şimdilik basitçe 30 güne oranlayalım.
        // Bu, gelecekte alışkanlığın programına göre iyileştirilebilir.
        guard !recentLogs.isEmpty else { return 0.0 }
        
        return Double(recentLogs.count) / 30.0
    }
    
    /// Belirli bir alışkanlığın o gün tamamlanıp tamamlanmadığını kontrol eder.
    /// - Parameter habit: Kontrol edilecek alışkanlık.
    /// - Returns: Tamamlanmışsa `true`, değilse `false`.
    func isCompletedToday(for habit: Habit) -> Bool {
        return habit.logs.contains(where: { log in
            Calendar.current.isDate(log.date, inSameDayAs: Date()) && log.status == .completed
        })
    }
}
