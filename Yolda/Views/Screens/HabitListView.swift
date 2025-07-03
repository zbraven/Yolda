
import SwiftUI
import SwiftData

/// Uygulamanın ana ekranı. Kullanıcının tüm alışkanlıklarını listeler.
struct HabitListView: View {
    /// ViewModel'e erişim için EnvironmentObject kullanılır.
    @EnvironmentObject var viewModel: HabitViewModel
    
    /// Yeni alışkanlık ekleme ekranının (sheet) gösterilip gösterilmeyeceğini kontrol eder.
    @State private var isShowingAddHabitSheet = false
    
    /// iPad'de seçili olan alışkanlığı takip eder.
    @State private var selectedHabit: Habit? = nil
    
    var body: some View {
        NavigationSplitView {
            // Kenar Çubuğu (Sidebar)
            sidebar
                .navigationTitle("Alışkanlıklar")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { isShowingAddHabitSheet = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(Color("PrimaryColor"))
                        }
                    }
                }
        } detail: {
            // Detay Görünümü
            if let selectedHabit = selectedHabit {
                HabitDetailView(habit: selectedHabit)
            } else {
                Text("Bir alışkanlık seçin")
                    .font(.title)
                    .foregroundColor(.secondary)
            }
        }
        .sheet(isPresented: $isShowingAddHabitSheet) {
            AddHabitView()
                .environmentObject(viewModel)
        }
    }
    
    /// Alışkanlık listesini içeren kenar çubuğu.
    private var sidebar: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            
            if viewModel.habits.isEmpty {
                emptyStateView
            } else {
                habitList
            }
        }
    }
    
    /// Alışkanlık listesi boş olduğunda gösterilecek olan View.
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "road.lanes")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.6))
            Text("İlk Alışkanlığını Ekle")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Yola çıkmak için ‘+’ ikonuna dokun.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
    
    /// Alışkanlıkları listeleyen View.
    private var habitList: some View {
        List(selection: $selectedHabit) {
            ForEach(viewModel.habits) { habit in
                NavigationLink(value: habit) {
                    HabitRow(habit: habit)
                }
            }
            .onDelete(perform: deleteHabit)
            .listRowBackground(Color("BackgroundColor"))
            .listRowSeparator(.hidden)
        }
        .listStyle(PlainListStyle())
    }
    
    /// Listeden bir alışkanlığı silme fonksiyonu.
    private func deleteHabit(at offsets: IndexSet) {
        offsets.forEach { index in
            let habit = viewModel.habits[index]
            viewModel.deleteHabit(habit)
        }
    }
}

/// `HabitListView` içindeki her bir satırı temsil eden View.
struct HabitRow: View {
    @ObservedObject var habit: Habit
    @EnvironmentObject var viewModel: HabitViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            // Tamamlama butonu
            Button(action: { toggleCompletion() }) {
                Image(systemName: viewModel.isCompletedToday(for: habit) ? "checkmark.circle.fill" : "circle")
                    .font(.title)
                    .foregroundColor(viewModel.isCompletedToday(for: habit) ? Color("PrimaryColor") : .secondary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(.headline)
                    .fontWeight(.bold)
                
                HStack {
                    Text("Seri: \(viewModel.calculateStreak(for: habit)) gün")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Dönüm noktası rozeti
                    if let milestone = viewModel.checkMilestone(for: viewModel.calculateStreak(for: habit)) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text("\(milestone)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                    }
                }
            }
            
            Spacer()
            
            // Detay sayfasına gitmek için ikon
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary.opacity(0.5))
        }
        .padding()
        .background(Color("CardColor"))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    /// Alışkanlığın o günkü tamamlama durumunu değiştirir.
    private func toggleCompletion() {
        let isCompleted = viewModel.isCompletedToday(for: habit)
        
        // Haptic feedback ekle
        let haptic = UIImpactFeedbackGenerator(style: .medium)
        haptic.impactOccurred()
        
        // Animasyon ile değişiklik
        withAnimation {
            if isCompleted {
                // Tamamlanmış bir görevi geri almak için log'u sil
                if let log = habit.logs.first(where: { Calendar.current.isDate($0.date, inSameDayAs: Date()) && $0.status == .completed }) {
                    viewModel.modelContext.delete(log)
                    viewModel.fetchHabits() // Yeniden çizim için
                }
            } else {
                // Görevi tamamlandı olarak işaretle
                viewModel.logHabit(for: habit, on: Date(), with: .completed)
            }
        }
    }
}


#Preview {
    // Preview için sahte bir ModelContainer ve ViewModel oluşturalım.
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, HabitLog.self, configurations: config)
    
    // Örnek veri ekle
    let sampleHabit = Habit(name: "Kitap Oku", whyNote: "Daha bilge olmak için.")
    container.mainContext.insert(sampleHabit)
    
    let viewModel = HabitViewModel(modelContext: container.mainContext)
    
    return HabitListView()
        .environmentObject(viewModel)
}
