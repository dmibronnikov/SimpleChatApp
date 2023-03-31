import UIKit

final class ChatTitleView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(size: 16, weight: .semibold)
        label.textColor = .textPrimary
        label.textAlignment = .center
        
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(size: 12, weight: .regular)
        label.textColor = .textSecondary
        label.textAlignment = .center
        
        return label
    }()
    
    init(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        super.init(frame: .zero)
        
        [titleLabel, subtitleLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
