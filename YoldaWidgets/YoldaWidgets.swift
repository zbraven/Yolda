
import WidgetKit
import SwiftUI
import SwiftData

// MARK: - Widget'ın Zaman Çizelgesi ve Mantığı

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), habit: mockHabit)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), habit: fetchFirstHabit())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Her saat başı widget'ı güncellemek için bir zaman çizelgesi oluştur.
        let currentDate = Date()
        for hourOffset in 0..<5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, habit: fetchFirstHabit())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    /// Veritabanından ilk alışkanlığı çeker. Widget'ta göstermek için kullanılır.
    private func fetchFirstHabit() -> Habit? {
        // Ana uygulamadaki SwiftData container'ına erişim (paylaşılan bir App Group gerektirir)
        // Şimdilik mock data kullanıyoruz.
        return mockHabit
    }
    
    /// Widget önizlemesi ve snapshot için sahte alışkanlık verisi.
    private var mockHabit: Habit {
        Habit(name: "Kitap Oku", whyNote: "Daha bilge olmak için.")
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let habit: Habit?
}

// MARK: - Widget'ın Görünümü

struct YoldaWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        if let habit = entry.habit {
            switch family {
            case .systemSmall:
                SmallWidgetView(habit: habit)
            case .systemMedium:
                MediumWidgetView(habit: habit)
            default:
                Text("Bu boyut desteklenmiyor.")
            }
        } else {
            Text("Lütfen bir alışkanlık ekleyin.")
        }
    }
}

struct SmallWidgetView: View {
    let habit: Habit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(habit.name)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color("PrimaryTextColor"))
            
            Text("Seri: 15 gün") // TODO: Gerçek seri hesaplaması eklenecek
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            // Tamamlama butonu (gerçekte bir App Intent ile çalışır)
            Image(systemName: "checkmark.circle.fill")
                .font(.largeTitle)
                .foregroundColor(Color("PrimaryColor"))
        }
        .padding()
        .background(Color("CardColor"))
    }
}

struct MediumWidgetView: View {
    let habit: Habit
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(habit.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryTextColor"))
                
                Text("Seri: 15 gün")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text(habit.whyNote)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(Color("PrimaryColor"))
        }
        .padding()
        .background(Color("CardColor"))
    }
}

// MARK: - Widget Konfigürasyonu

@main
struct YoldaWidget: Widget {
    let kind: String = "YoldaWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) {
            YoldaWidgetEntryView(entry: $0)
        }
        .configurationDisplayName("Yolda Alışkanlık Takibi")
        .description("Alışkanlıklarını ana ekranından takip et.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemMedium) {
    YoldaWidget()
} timeline: {
    SimpleEntry(date: .now, habit: Habit(name: "Meditasyon Yap", whyNote: "Zihnimi sakinleştirmek için."))
    SimpleEntry(date: .now, habit: Habit(name: "Su İç", whyNote: "Sağlıklı kalmak için."))
}
