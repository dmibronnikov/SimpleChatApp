import UIKit

final class ChatTextCell: UITableViewCell {
    private let avatarView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 15
        
        return view
    }()
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(size: 12, weight: .semibold)
        label.textColor = .textSecondary
        
        return label
    }()
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(size: 15, weight: .regular)
        label.textColor = .textPrimary
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        [avatarView, usernameLabel, bodyLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        transform = CGAffineTransform(scaleX: 1, y: -1)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            avatarView.widthAnchor.constraint(equalToConstant: 40),
            avatarView.heightAnchor.constraint(equalToConstant: 40),
            avatarView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -6)
        ])
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 15),
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6)
        ])
        NSLayoutConstraint.activate([
            bodyLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 15),
            bodyLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            bodyLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -6)
        ])
    }
    
    func configure(messageId: Int, text: String, sender: User) {
        usernameLabel.text = sender.username
        bodyLabel.text = text
    }
}
