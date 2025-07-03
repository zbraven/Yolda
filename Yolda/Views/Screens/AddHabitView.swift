
import SwiftUI

/// Yeni bir alışkanlık eklemek için kullanılan ekran.
struct AddHabitView: View {
    /// ViewModel'e erişim için EnvironmentObject kullanılır.
    @EnvironmentObject var viewModel: HabitViewModel
    
    /// View'ı kapatmak için kullanılır.
    @Environment(\.dismiss) var dismiss
    
    /// Alışkanlık adı için state.
    @State private var name: String = ""
    
    /// "Neden Başladın?" notu için state.
    @State private var whyNote: String = ""
    
    /// Formun geçerli olup olmadığını kontrol eder.
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Alışkanlık Detayları").font(.headline)) {
                    TextField("Alışkanlık Adı (örn: Her gün 10 sayfa kitap oku)", text: $name)
                    TextField("Neden başladığını hatırla...", text: $whyNote, axis: .vertical)
                        .lineLimit(4...)
                }
                .listRowBackground(Color("CardColor"))
            }
            .background(Color("BackgroundColor"))
            .scrollContentBackground(.hidden) // Formun kendi arka planını kaldırır
            .navigationTitle("Yeni Alışkanlık")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Kapatma butonu
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Vazgeç") {
                        dismiss()
                    }
                    .foregroundColor(Color("PrimaryColor"))
                }
                // Kaydetme butonu
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        saveHabit()
                    }
                    .disabled(!isFormValid)
                    .foregroundColor(isFormValid ? Color("PrimaryColor") : .gray)
                }
            }
        }
    }
    
    /// Girilen bilgileri kullanarak yeni alışkanlığı kaydeder.
    private func saveHabit() {
        viewModel.addHabit(name: name, whyNote: whyNote)
        dismiss() // Ekranı kapat
    }
}

#Preview {
    // Preview için sahte bir ModelContainer ve ViewModel oluşturalım.
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, HabitLog.self, configurations: config)
    let viewModel = HabitViewModel(modelContext: container.mainContext)
    
    return AddHabitView()
        .environmentObject(viewModel)
}
