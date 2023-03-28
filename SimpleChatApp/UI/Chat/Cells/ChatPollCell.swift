import UIKit

final class ChatPollCell: UITableViewCell {
    private let containerView: UIView = .init()
    private let avatarView: UIView = .init()
    private let usernameLabel: UILabel = .init()
    private let pollTypeLabel: UILabel = .init()
    private let pollVotesView: UIView = .init()
    private let pollQuestionLabel: UILabel = .init()
    private var pollOptionViews: [UIView] = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        [avatarView, usernameLabel, pollTypeLabel, pollVotesView, pollQuestionLabel].forEach {
            containerView.addSubview($0)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pollOptionViews.forEach { $0.removeFromSuperview() }
        pollOptionViews.removeAll()
    }
    
    func configure(messageId: Int, poll: Poll, sender: User) {
        
    }
}

extension ChatPollCell {
    class LayoutItem {
        let frame: CGRect
        let type: LayoutItemType
        let children: [LayoutItem]
        
        init(frame: CGRect, type: LayoutItemType, children: [LayoutItem] = []) {
            self.frame = frame
            self.type = type
            self.children = children
        }
    }
    
    enum LayoutItemType {
        case container
        case avatar
        case username(NSAttributedString)
        case pollType(NSAttributedString)
        case pollVotes(NSAttributedString, NSAttributedString)
        case pollQuestion(NSAttributedString)
        case pollOption(NSAttributedString)
    }
    
    static func calculateLayout(poll: Poll, sender: User, widthLimit: CGFloat) -> LayoutItem {
        var containerChildren: [LayoutItem] = []
        let avatarSize = CGSize(width: 36, height: 36)
        let xInset: CGFloat = 10
        let totalVotesSize = CGSize(width: 50, height: 50)
        
        let avatarFrame = CGRect(origin: CGPoint(x: 20, y: 20), size: avatarSize)
        containerChildren.append(LayoutItem(frame: avatarFrame, type: .avatar))
        
        let totalVotesFrame = CGRect(
            origin: CGPoint(x: widthLimit - totalVotesSize.width + 20, y: 12),
            size: totalVotesSize
        )
        let votesCountString = NSAttributedString(string: "\(poll.votes)", attributes: textPrimarySemibold16Attributes)
        let votesString = NSAttributedString(string: "votes", attributes: textPrimaryRegular10Attributes)
        containerChildren.append(LayoutItem(frame: totalVotesFrame, type: .pollVotes(votesCountString, votesString)))
        
        let pollType = NSAttributedString(string: "public poll", attributes: textPrimaryRegular10Attributes)
        let pollTypeSize = pollType.size(with: CGSize(
            width: widthLimit - avatarFrame.maxX - xInset,
            height: CGFloat.infinity
        ))
        let pollTypeFrame = CGRect(
            origin: CGPoint(x: avatarFrame.maxX + xInset, y: 20),
            size: pollTypeSize
        )
        containerChildren.append(LayoutItem(frame: pollTypeFrame, type: .pollType(pollType)))
        
        let username = NSAttributedString(string: sender.username, attributes: textPrimarySemibold12Attributes)
        let usernameSize = username.size(with: CGSize(
            width: widthLimit - avatarFrame.maxX - xInset,
            height: CGFloat.infinity
        ))
        let usernameFrame = CGRect(
            origin: CGPoint(x: avatarFrame.maxX + xInset, y: pollTypeFrame.maxY + 2),
            size: usernameSize
        )
        containerChildren.append(LayoutItem(frame: usernameFrame, type: .username(username)))
        
        let question = NSAttributedString(string: poll.question, attributes: textPrimaryMedium15Attributes)
        let questionFrame = CGRect(
            origin: CGPoint(x: 20, y: avatarFrame.maxY + 20),
            size: question.size(with: CGSize(width: widthLimit, height: CGFloat.infinity))
        )
        containerChildren.append(LayoutItem(frame: questionFrame, type: .pollQuestion(question)))
        
        let optionSize = CGSize(width: widthLimit, height: 40)
        let startingOptionY: CGFloat = questionFrame.maxY + 12
        var pollOptions: [LayoutItem] = []
        for (index, option) in poll.options.enumerated() {
            let optionFrame = CGRect(
                origin: CGPoint(x: 20, y: startingOptionY + (optionSize.height + 8) * CGFloat(index)),
                size: optionSize
            )

            let optionString = NSAttributedString(string: option.text, attributes: textPrimaryRegular12Attributes)
            pollOptions.append(LayoutItem(frame: optionFrame, type: .pollOption(optionString)))
        }
        
        
    }
}

private extension NSAttributedString {
    func size(with boundingSize: CGSize) -> CGSize {
        self.boundingRect(
            with: boundingSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil).size
    }
}

//private static func calculatePollLayout(poll: Poll, sender: User, widthLimit: CGFloat) -> Layout {
//    var items: [(item: Item, frame: CGRect)] = []
//
//    let avatarSize = CGSize(width: 36, height: 36)
//    let xInset: CGFloat = 10
//    let totalVotesSize = CGSize(width: 50, height: 50)
//
//    let avatarFrame = CGRect(origin: CGPoint(x: 20, y: 20), size: avatarSize)
//    items.append((Item.view(type: .avatar(cornerRadius: 13)), avatarFrame))
//
//    let totalVotesFrame = CGRect(
//        origin: CGPoint(x: widthLimit - totalVotesSize.width + 20, y: 12),
//        size: totalVotesSize
//    )
//    let votesString = NSAttributedString(string: "votes", attributes: textPrimaryRegular10Attributes)
//    items.append((Item.view(type: .pollTotalVotes(count: poll.votes, text: votesString)), totalVotesFrame))
//
//    let pollType = NSAttributedString(string: "public poll", attributes: textPrimaryRegular10Attributes)
//    let pollTypeSize = pollType.size(with: CGSize(
//        width: widthLimit - avatarFrame.maxX - xInset,
//        height: CGFloat.infinity
//    ))
//    let pollTypeFrame = CGRect(
//        origin: CGPoint(x: avatarFrame.maxX + xInset, y: 20),
//        size: pollTypeSize
//    )
//    items.append((Item.text(text: pollType), pollTypeFrame))
//
//    let username = NSAttributedString(string: sender.username, attributes: textPrimarySemibold12Attributes)
//    let usernameSize = username.size(with: CGSize(
//        width: widthLimit - avatarFrame.maxX - xInset,
//        height: CGFloat.infinity
//    ))
//    let usernameFrame = CGRect(
//        origin: CGPoint(x: avatarFrame.maxX + xInset, y: pollTypeFrame.maxY + 2),
//        size: usernameSize
//    )
//    items.append((Item.text(text: username), usernameFrame))
//
//    let question = NSAttributedString(string: poll.question, attributes: textPrimaryMedium15Attributes)
//    let questionFrame = CGRect(
//        origin: CGPoint(x: 20, y: avatarFrame.maxY + 20),
//        size: question.size(with: CGSize(width: widthLimit, height: CGFloat.infinity))
//    )
//    items.append((Item.text(text: question), questionFrame))
//
//    let optionSize = CGSize(width: widthLimit, height: 40)
//    let startingOptionY: CGFloat = questionFrame.maxY + 12
//    for (index, option) in poll.options.enumerated() {
//        let optionFrame = CGRect(
//            origin: CGPoint(x: 20, y: startingOptionY + (optionSize.height + 8) * CGFloat(index)),
//            size: optionSize
//        )
//
//        let optionString = NSAttributedString(string: option.text, attributes: textPrimaryRegular12Attributes)
//        items.append((Item.view(type: .pollOption(text: optionString)), optionFrame))
//    }
//
//    let messageSize = CGSize(width: widthLimit, height: items.last!.frame.maxY + 20)
//    return Layout(items: items, size: messageSize)
//}

private let textPrimaryRegular10Attributes: [NSAttributedString.Key: Any] = [
    .font: UIFont.appFont(size: 10, weight: .regular),
    .foregroundColor: UIColor.textPrimary
]

private let textPrimaryRegular12Attributes: [NSAttributedString.Key: Any] = [
    .font: UIFont.appFont(size: 12, weight: .regular),
    .foregroundColor: UIColor.textPrimary
]

private let textPrimarySemibold12Attributes: [NSAttributedString.Key: Any] = [
    .font: UIFont.appFont(size: 12, weight: .semibold),
    .foregroundColor: UIColor.textPrimary
]

private let textSecondarySemibold12Attributes: [NSAttributedString.Key: Any] = [
    .font: UIFont.appFont(size: 12, weight: .semibold),
    .foregroundColor: UIColor.textSecondary
]

private let textPrimaryRegular15Attributes: [NSAttributedString.Key: Any] = [
    .font: UIFont.appFont(size: 15, weight: .regular),
    .foregroundColor: UIColor.textPrimary
]

private let textPrimaryMedium15Attributes: [NSAttributedString.Key: Any] = [
    .font: UIFont.appFont(size: 15, weight: .medium),
    .foregroundColor: UIColor.textPrimary
]

private let textPrimarySemibold16Attributes: [NSAttributedString.Key: Any] = [
    .font: UIFont.appFont(size: 16, weight: .semibold),
    .foregroundColor: UIColor.textPrimary
]

