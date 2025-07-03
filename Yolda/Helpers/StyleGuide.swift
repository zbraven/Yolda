
import SwiftUI

/// Uygulama genelinde kullanılacak olan renkleri, fontları ve diğer stil sabitlerini tanımlar.
/// Bu merkezi yapı, uygulamanın görsel kimliğini tutarlı ve kolay yönetilebilir kılar.
extension Color {
    // MARK: - Renk Paleti
    // Renkler, hem Light hem de Dark Mode'a uyum sağlayacak şekilde
    // Assets.xcassets içinde tanımlanmalıdır. Bu isimlendirme, oradaki isimlerle eşleşir.
    
    /// Ana arka plan rengi. Genellikle en dış katmanda kullanılır.
    static let BackgroundColor = Color("BackgroundColor")
    
    /// Kartlar, list item'ları gibi ikincil yüzeylerin arka plan rengi.
    static let CardColor = Color("CardColor")
    
    /// Butonlar, ikonlar gibi vurgu yapılması istenen ana renk.
    static let PrimaryColor = Color("PrimaryColor")
    
    /// Ana metin rengi. Yüksek kontrasta sahip olmalıdır.
    static let PrimaryTextColor = Color("PrimaryTextColor")
    
    /// İkincil metinler, açıklamalar için kullanılan renk.
    static let SecondaryTextColor = Color("SecondaryTextColor")
}

/*
 NOT: Bu renkleri kullanabilmek için projedeki `Assets.xcassets` dosyasına gidip
 aşağıdaki isimlerle "Color Set" oluşturmak gerekmektedir:
 
 - BackgroundColor
 - CardColor
 - PrimaryColor
 - PrimaryTextColor
 - SecondaryTextColor
 
 Her bir renk seti için "Any Appearance" (Light Mode) ve "Dark Appearance" (Dark Mode)
 renklerini belirleyerek uygulamanın iki modda da harika görünmesini sağlayabilirsiniz.
 
 Örnek Renk Değerleri (Minimalist ve Sakin bir palet için):
 
 Light Mode:
 - BackgroundColor: #F5F5F7 (Çok açık gri)
 - CardColor:       #FFFFFF (Beyaz)
 - PrimaryColor:    #3A86FF (Canlı Mavi)
 - PrimaryTextColor:  #1D1D1F (Siyaha yakın)
 - SecondaryTextColor:#6E6E73 (Orta Gri)
 
 Dark Mode:
 - BackgroundColor: #000000 (Siyah)
 - CardColor:       #1C1C1E (Koyu Gri)
 - PrimaryColor:    #3A86FF (Canlı Mavi)
 - PrimaryTextColor:  #FFFFFF (Beyaz)
 - SecondaryTextColor:#8E8E93 (Açık Gri)

 */
