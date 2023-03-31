import UIKit

final class GradientView: UIView {
    override class var layerClass: AnyClass { CAGradientLayer.self }
    
    private var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    var colors: [CGColor] = [] {
        didSet {
            gradientLayer.colors = colors
        }
    }
    
    var locations: [NSNumber] = [] {
        didSet {
            gradientLayer.locations = locations
        }
    }
    
    var startPoint: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            gradientLayer.startPoint = startPoint
        }
    }
    
    var endPoint: CGPoint = CGPoint(x: 0, y: 1) {
        didSet {
            gradientLayer.endPoint = endPoint
        }
    }
}
