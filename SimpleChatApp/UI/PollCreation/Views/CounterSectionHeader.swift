import UIKit

final class CounterSectionHeader: UIView {
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(size: 12, weight: .semibold)
        label.textColor = .textSecondary
        
        return label
    }()
    
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(size: 12, weight: .regular)
        label.textColor = .textSecondary
        
        return label
    }()
    
    private var maxCount: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        [textLabel, counterLabel].forEach { addSubview($0) }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel.sizeToFit()
        counterLabel.sizeToFit()
        
        textLabel.frame = bounds
            .divided(atDistance: 20, from: .minXEdge).remainder
            .divided(atDistance: textLabel.bounds.width, from: .minXEdge).slice
        counterLabel.frame = bounds
            .divided(atDistance: 20, from: .maxXEdge).remainder
            .divided(atDistance: counterLabel.bounds.width, from: .maxXEdge).slice
    }
    
    func configure(text: String, maxCount: Int) {
        self.maxCount = maxCount
        
        textLabel.text = text
        counterLabel.text = "\(0)/\(maxCount)"
    }
    
    func update(with count: Int) {
        counterLabel.text = "\(count)/\(maxCount)"
        setNeedsLayout()
    }
}
