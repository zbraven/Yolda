
import SwiftUI

/// Bir alışkanlığın detaylarını, takvimini ve notlarını gösteren ekran.
struct HabitDetailView: View {
    /// Görüntülenen alışkanlık.
    @ObservedObject var habit: Habit
    
    /// ViewModel'e erişim.
    @EnvironmentObject var viewModel: HabitViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                // "Neden Başladım?" Notu Bölümü
                VStack(alignment: .leading, spacing: 10) {
                    Text("Yola Çıkma Nedenin")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("PrimaryTextColor"))
                    
                    Text(habit.whyNote)
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color("CardColor"))
                        .cornerRadius(12)
                }
                
                // Takvim Bölümü (Milestone 2'de eklenecek)
                VStack(alignment: .leading, spacing: 10) {
                    Text("İlerleme Takvimi")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("PrimaryTextColor"))
                    
                    // Takvim görünümünü gösterir.
                    CalendarView(habit: habit)
                }
                
                // İstatistik Bölümü
                VStack(alignment: .leading, spacing: 10) {
                    Text("Performans")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("PrimaryTextColor"))
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Son 30 Gün")
                                .font(.headline)
                            Text("Tamamlama Oranı")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(String(format: "%%%.0f", viewModel.calculateMonthlyCompletionRate(for: habit) * 100))
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(Color("PrimaryColor"))
                    }
                    .padding()
                    .background(Color("CardColor"))
                    .cornerRadius(12)
                }
                
                // Eylemler Bölümü
                actionButtons
            }
            .padding()
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .navigationTitle(habit.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    /// "Duraklat" ve "Sıfırla" eylemleri için butonları içeren View.
    private var actionButtons: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Eylemler")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("PrimaryTextColor"))
            
            // Duraklatma Butonu
            Button(action: {
                viewModel.pauseHabit(habit, on: Date())
            }) {
                HStack {
                    Image(systemName: "pause.fill")
                    Text("Bugünü Pas Geç")
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .foregroundColor(Color("PrimaryTextColor"))
            .cornerRadius(12)
            
            // Sıfırlama Butonu
            Button(action: {
                // TODO: Sıfırlama için not sorma mekanizması eklenecek.
                // Şimdilik not olmadan sıfırlayalım.
                viewModel.resetStreak(for: habit, on: Date(), note: "Kullanıcı notu eklenecek.")
            }) {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Seriyi Sıfırla")
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color.red.opacity(0.2))
            .foregroundColor(.red)
            .cornerRadius(12)
            
            // Arşivleme Butonu
            Button(action: {
                viewModel.archiveHabit(habit)
            }) {
                HStack {
                    Image(systemName: "archivebox.fill")
                    Text("Alışkanlığı Arşivle")
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color.blue.opacity(0.2))
            .foregroundColor(.blue)
            .cornerRadius(12)
        }
    }
}

#Preview {
    // Preview için sahte bir ModelContainer ve ViewModel oluşturalım.
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, HabitLog.self, configurations: config)
    
    let sampleHabit = Habit(name: "Erken Uyan", whyNote: "Güne daha enerjik ve verimli başlamak için.")
    container.mainContext.insert(sampleHabit)
    
    let viewModel = HabitViewModel(modelContext: container.mainContext)
    
    return NavigationView {
        HabitDetailView(habit: sampleHabit)
            .environmentObject(viewModel)
    }
}
