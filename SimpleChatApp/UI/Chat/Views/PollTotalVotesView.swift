import UIKit

final class PollTotalVotesView: UIView {
    private let votesCountLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(size: 16, weight: .semibold)
        label.textColor = .textPrimary
        return label
    }()
    private let votesLabel: UILabel = {
        let label = UILabel()
        label.text = "votes"
        label.font = .appFont(size: 10, weight: .regular)
        label.textColor = .textPrimary
        
        return label
    }()
    
    var votes: Int = 0 {
        didSet {
            votesCountLabel.text = "\(votes)"
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [votesLabel, votesCountLabel].forEach { addSubview($0) }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        votesCountLabel.sizeToFit()
        votesLabel.sizeToFit()
        
        var votesCountLabelFrame = votesCountLabel.frame
        votesCountLabelFrame.origin = CGPoint(
            x: (bounds.width - votesCountLabelFrame.width) / 2,
            y: 8
        )
        votesCountLabel.frame = votesCountLabelFrame
        
        var votesLabelFrame = votesLabel.frame
        votesLabelFrame.origin = CGPoint(
            x: (bounds.width - votesLabelFrame.width) / 2,
            y: bounds.height - votesLabelFrame.height - 8
        )
        votesLabel.frame = votesLabelFrame
    }
}
