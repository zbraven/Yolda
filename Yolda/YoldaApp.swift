
import SwiftUI
import SwiftData

/// Uygulamanın ana giriş noktası (entry point).
@main
struct YoldaApp: App {
    
    /// SwiftData için paylaşılan model container.
    /// Veritabanı şeması olarak Habit ve HabitLog modellerini içerir.
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Habit.self,
            HabitLog.self,
        ])
        // iCloud senkronizasyonunu etkinleştirmek için .automatic kullanılır.
        // Gerçek bir uygulamada, proje ayarlarında iCloud yeteneğinin (capability) ve
        // bir App Group'un yapılandırılması gerekir.
        let modelConfiguration = ModelConfiguration(schema: schema, cloudKitDatabase: .automatic)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    /// Uygulama genelinde kullanılacak olan ana ViewModel.
    /// Model container'ın mainContext'i ile başlatılır.
    @StateObject var viewModel: HabitViewModel
    
    init() {
        // StateObject'i init içinde bu şekilde başlatmak, 
        // sharedModelContainer'a erişim için en doğru yöntemdir.
        _viewModel = StateObject(wrappedValue: HabitViewModel(modelContext: sharedModelContainer.mainContext))
    }

    var body: some Scene {
        WindowGroup {
            HabitListView()
                // ViewModel'i tüm alt view'ların erişebilmesi için environment object olarak ekler.
                .environmentObject(viewModel)
        }
        // SwiftData model container'ını view hiyerarşisine ekler.
        .modelContainer(sharedModelContainer)
    }
}
