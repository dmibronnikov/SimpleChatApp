import UIKit

final class ChatPollCell: UITableViewCell {
    private let containerView: UIView = {
        let colors: [CGColor] = [
            UIColor.redPurple,
            UIColor.seance,
            UIColor.windsor,
            UIColor.tangaroa
        ].map(\.cgColor)
        
        let view = GradientView()
        view.colors = colors
        view.locations = [0.05, 0.2, 0.5, 0.75]
        view.startPoint = CGPoint(x: 0, y: 0)
        view.endPoint = CGPoint(x: 1, y: 1)
        view.layer.cornerRadius = 18
        return view
    }()
    private let avatarView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 13
        
        return view
    }()
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(size: 12, weight: .semibold)
        label.textColor = .textPrimary
        
        return label
    }()
    private let pollTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "public poll"
        label.font = .appFont(size: 10, weight: .regular)
        label.textColor = .textPrimary
        
        return label
    }()
    private let totalVotesView: PollTotalVotesView = {
        let view = PollTotalVotesView()
        view.backgroundColor = .pink
        view.layer.cornerRadius = 25
        
        return view
    }()
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(size: 15, weight: .medium)
        label.textColor = .textPrimary
        
        return label
    }()
    private var pollOptionViews: [PollOptionView] = []
    
    private let containerGradientLayer: CAGradientLayer = {
        let colors: [CGColor] = [
            UIColor.redPurple,
            UIColor.seance,
            UIColor.windsor,
            UIColor.tangaroa
        ].map(\.cgColor)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = [0.1, 0.2, 0.5, 0.75]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        return gradientLayer
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        [avatarView, usernameLabel, pollTypeLabel, totalVotesView, questionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
        NSLayoutConstraint.activate([
            totalVotesView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            totalVotesView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            totalVotesView.widthAnchor.constraint(equalToConstant: 50),
            totalVotesView.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            avatarView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            avatarView.widthAnchor.constraint(equalToConstant: 36),
            avatarView.heightAnchor.constraint(equalToConstant: 36)
        ])
        NSLayoutConstraint.activate([
            pollTypeLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10),
            pollTypeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            usernameLabel.leadingAnchor.constraint(equalTo: pollTypeLabel.leadingAnchor),
            usernameLabel.topAnchor.constraint(equalTo: pollTypeLabel.bottomAnchor, constant: 2)
        ])
        NSLayoutConstraint.activate([
            questionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            questionLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            questionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pollOptionViews.forEach { $0.removeFromSuperview() }
        pollOptionViews.removeAll()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerGradientLayer.frame = containerView.bounds
    }
    
    func configure(messageId: Int, poll: Poll, sender: User) {
        usernameLabel.text = sender.username
        totalVotesView.votes = poll.votes
        questionLabel.text = poll.question
        
        for option in poll.options {
            let optionView = PollOptionView()
            optionView.text = option.text
            
            containerView.addSubview(optionView)
            optionView.translatesAutoresizingMaskIntoConstraints = false
            
            let lastView = pollOptionViews.last ?? questionLabel
            NSLayoutConstraint.activate([
                optionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                optionView.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 12),
                optionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                optionView.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            pollOptionViews.append(optionView)
        }
        
        guard let lastOptionView = pollOptionViews.last else { return }
        lastOptionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
    }
}
