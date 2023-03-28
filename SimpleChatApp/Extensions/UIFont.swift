import UIKit

extension UIFont {
    static func appFont(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let fontName = "Poppins-\(weightString(from: weight))"
        
        guard let font = UIFont(name: fontName, size: size) else {
            return .systemFont(ofSize: size, weight: weight)
        }
        
        return font
    }
    
    private static func weightString(from weight: UIFont.Weight) -> String {
        switch weight {
        case .medium:
            return "Medium"
        case .semibold:
            return "SemiBold"
        default:
            return "Regular"
        }
    }
}
