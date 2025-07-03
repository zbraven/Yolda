
import Foundation
import SwiftData

/// Uygulamadaki bir alışkanlığı temsil eden ana veri modeli.
/// SwiftData tarafından yönetilir ve veritabanında saklanır.
@Model
final class Habit {
    /// Benzersiz kimlik
    @Attribute(.unique) var id: UUID
    
    /// Alışkanlığın adı (örn: "Kitap Oku")
    var name: String
    
    /// Kullanıcının bu alışkanlığa neden başladığını hatırlatan motivasyon notu.
    var whyNote: String
    
    /// Alışkanlığın oluşturulduğu tarih.
    var creationDate: Date
    
    /// Alışkanlığın aktif olup olmadığını belirtir.
    var isActive: Bool
    
    /// Alışkanlığın arşivlenip arşivlenmediğini belirtir.
    var isArchived: Bool
    
    /// Alışkanlık tamamlama kayıtları. One-to-Many ilişki.
    @Relationship(deleteRule: .cascade, inverse: \HabitLog.habit)
    var logs: [HabitLog]
    
    init(name: String, whyNote: String, creationDate: Date = .now) {
        self.id = UUID()
        self.name = name
        self.whyNote = whyNote
        self.creationDate = creationDate
        self.isActive = true
        self.isArchived = false
        self.logs = []
    }
}
