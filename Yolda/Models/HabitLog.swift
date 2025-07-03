
import Foundation
import SwiftData

/// Alışkanlıkların günlük durumlarını (tamamlandı, sıfırlandı vb.) kaydeden veri modeli.
@Model
final class HabitLog {
    /// Benzersiz kimlik
    @Attribute(.unique) var id: UUID
    
    /// Kaydın oluşturulduğu tarih (sadece gün, ay, yıl önemlidir).
    var date: Date
    
    /// Kaydın durumu.
    var status: LogStatus
    
    /// Eğer alışkanlık sıfırlandıysa, kullanıcının nedenini belirttiği not.
    var resetNote: String?
    
    /// Bu kaydın hangi alışkanlığa ait olduğunu belirtir. Many-to-One ilişki.
    var habit: Habit?
    
    init(date: Date, status: LogStatus, resetNote: String? = nil) {
        self.id = UUID()
        self.date = date
        self.status = status
        self.resetNote = resetNote
    }
}

/// Alışkanlık kaydının durumunu belirten enum.
/// Codable ve CaseIterable yapılarak kullanımı kolaylaştırılmıştır.
enum LogStatus: String, Codable, CaseIterable {
    case completed = "Tamamlandı"
    case reset = "Sıfırlandı"
    case paused = "Duraklatıldı"
    
    /// Takvimde görünecek ikon.
    var icon: String {
        switch self {
        case .completed: return "checkmark.circle.fill"
        case .reset: return "xmark.circle.fill"
        case .paused: return "pause.circle.fill"
        }
    }
}
