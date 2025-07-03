import SwiftUI

/// Alışkanlıkların ilerlemesini aylık bir takvim üzerinde gösteren, yeniden kullanılabilir View.
struct CalendarView: View {
    /// Takvimin göstereceği ay.
    @State private var month: Date = .now
    
    /// Takvim verilerini sağlayacak olan alışkanlık.
    let habit: Habit
    
    private let daysOfWeek = ["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"]
    
    var body: some View {
        VStack {
            header
            calendarGrid
        }
        .padding()
        .background(Color("CardColor"))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    /// Takvimin başlığı ve ay değiştirme butonları.
    private var header: some View {
        HStack {
            Button(action: { changeMonth(by: -1) }) {
                Image(systemName: "chevron.left.circle.fill")
            }
            
            Spacer()
            
            Text(month, formatter: DateFormatter.monthAndYear)
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button(action: { changeMonth(by: 1) }) {
                Image(systemName: "chevron.right.circle.fill")
            }
        }
        .foregroundColor(Color("PrimaryColor"))
        .font(.title2)
        .padding(.bottom, 10)
    }
    
    /// Takvimin günlerini içeren grid yapısı.
    private var calendarGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
            
            ForEach(fetchDaysInMonth(), id: \.self) { date in
                if let date = date {
                    dayCell(for: date)
                } else {
                    Rectangle().fill(Color.clear)
                }
            }
        }
    }
    
    /// Belirli bir gün için takvim hücresini oluşturan View.
    private func dayCell(for date: Date) -> some View {
        let status = status(for: date)
        
        return ZStack {
            Text("\(dayNumber(from: date))")
                .frame(width: 32, height: 32)
                .background(cellBackground(for: status, date: date))
                .clipShape(Circle())
                .foregroundColor(cellForegroundColor(for: status, date: date))
                .font(.system(size: 14))
        }
    }
    
    // MARK: - Cell Styling
    
    @ViewBuilder
    private func cellBackground(for status: LogStatus?, date: Date) -> some View {
        if let status = status {
            switch status {
            case .completed: Color("PrimaryColor")
            case .reset: Color.red.opacity(0.8)
            case .paused: Color.gray.opacity(0.5)
            }
        } else {
            if Calendar.current.isDateInToday(date) {
                Color.gray.opacity(0.25)
            } else {
                Color.clear
            }
        }
    }
    
    private func cellForegroundColor(for status: LogStatus?, date: Date) -> Color {
        if status != nil {
            return .white
        } else if Calendar.current.isDateInToday(date) {
            return Color("PrimaryTextColor")
        } else {
            return .secondary
        }
    }
    
    // MARK: - Helper Functions
    
    /// Takvimde gösterilecek ayı değiştirir.
    private func changeMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: month) {
            month = newMonth
        }
    }
    
    /// Belirtilen aydaki günleri, haftanın doğru gününde başlaması için boşluklarla birlikte döndürür.
    private func fetchDaysInMonth() -> [Date?] {
        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: month),
              let monthFirstWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: monthInterval.start)
        else { return [] }
        
        // Haftanın başlangıcını Pazartesi olarak ayarlamak için (Türkiye standardı)
        let firstDayOfWeek = Calendar.current.component(.weekday, from: monthInterval.start)
        // Swift's weekday: 1=Sun, 2=Mon, ..., 7=Sat. We want 1=Mon.
        let weekdayOffset = (firstDayOfWeek == 1) ? 6 : (firstDayOfWeek - 2)
        
        var days: [Date?] = Array(repeating: nil, count: weekdayOffset)
        
        let numberOfDays = Calendar.current.range(of: .day, in: .month, for: month)!.count
        for day in 1...numberOfDays {
            if let date = Calendar.current.date(byAdding: .day, value: day - 1, to: monthInterval.start) {
                days.append(date)
            }
        }
        return days
    }
    
    /// Tarihten sadece gün numarasını alır.
    private func dayNumber(from date: Date) -> String {
        return String(Calendar.current.component(.day, from: date))
    }
    
    /// Belirli bir tarih için alışkanlığın durumunu (LogStatus) döndürür.
    private func status(for date: Date) -> LogStatus? {
        return habit.logs.first { log in
            Calendar.current.isDate(log.date, inSameDayAs: date)
        }?.status
    }
}

/// Tarih formatlayıcıları için yardımcı extension.
extension DateFormatter {
    static let monthAndYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter
    }()
}

#Preview {
    // Preview için sahte veri oluşturalım
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, HabitLog.self, configurations: config)
    
    let habit = Habit(name: "Test Alışkanlığı", whyNote: "Test Notu")
    // Örnek loglar ekle
    let today = Date()
    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
    let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!
    let pausedDay = Calendar.current.date(byAdding: .day, value: -5, to: today)!
    
    let log1 = HabitLog(date: today, status: .completed)
    log1.habit = habit
    let log2 = HabitLog(date: yesterday, status: .completed)
    log2.habit = habit
    let log3 = HabitLog(date: twoDaysAgo, status: .reset, resetNote: "Unuttum")
    log3.habit = habit
    let log4 = HabitLog(date: pausedDay, status: .paused)
    log4.habit = habit
    
    container.mainContext.insert(habit)
    container.mainContext.insert(log1)
    container.mainContext.insert(log2)
    container.mainContext.insert(log3)
    container.mainContext.insert(log4)
    
    return CalendarView(habit: habit)
}