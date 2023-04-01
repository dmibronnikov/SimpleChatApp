import UIKit

private let containerYInset: CGFloat = 4

final class PollCreationAddOptionCell: UITableViewCell {
    static let height: CGFloat = 50 + containerYInset * 2
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightBackground
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Add an option"
        label.textColor = .accent
        label.font = .appFont(size: 15, weight: .regular)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(label)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.frame = contentView.bounds
            .insetBy(dx: 20, dy: containerYInset)
        
        label.frame = containerView.bounds
            .insetBy(dx: 15, dy: 15)
    }
}
