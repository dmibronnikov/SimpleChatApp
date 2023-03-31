import UIKit

final class PollOptionView: UIView {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .accent.withAlphaComponent(0.15)
        view.layer.cornerRadius = 15
        
        return view
    }()
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(size: 12, weight: .regular)
        label.textColor = .textPrimary
        
        return label
    }()
    
    var text: String = "" {
        didSet {
            textLabel.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(containerView)
        containerView.addSubview(textLabel)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.frame = bounds
        
        textLabel.sizeToFit()
        var textLabelFrame = textLabel.frame
        textLabelFrame.origin = CGPoint(
            x: 15,
            y: (containerView.frame.height - textLabelFrame.height) / 2
        )
        textLabel.frame = textLabelFrame
    }
}
