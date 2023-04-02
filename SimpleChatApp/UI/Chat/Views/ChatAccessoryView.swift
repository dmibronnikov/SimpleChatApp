import UIKit

private let buttonSize: CGSize = CGSize(width: 24, height: 24)
private let textViewMinHeight: CGFloat = 35
private let textViewMaxHeight: CGFloat = 120
private let edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 8, right: 20)

final class ChatAccessoryView: UIView, UITextViewDelegate {
    struct Actions {
        let sendText: (_ text: String) -> Void
        let createPoll: () -> Void
    }
    var actions: Actions!

    private let pollButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private let textView: FlexibleTextView = {
        let textView = FlexibleTextView()
        textView.attributedPlaceholder = NSAttributedString(
            string: "Message",
            attributes: [
                .foregroundColor: UIColor.textSecondary,
                .font: UIFont.appFont(size: 15, weight: .regular)
            ]
        )
        textView.backgroundColor = .lightBackground
        textView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        textView.maxHeight = textViewMaxHeight
        textView.textColor = .textPrimary
        textView.font = .appFont(size: 15, weight: .regular)
        textView.layer.cornerRadius = 10
        
        return textView
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [pollButton, textView, sendButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .background
        
        let buttonBottomInset = (textViewMinHeight - buttonSize.height) / 2 + edgeInsets.bottom
        
        NSLayoutConstraint.activate([
            pollButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: edgeInsets.left),
            pollButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -buttonBottomInset),
            pollButton.widthAnchor.constraint(equalToConstant: buttonSize.width),
            pollButton.heightAnchor.constraint(equalToConstant: buttonSize.height)
        ])
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: pollButton.trailingAnchor, constant: 15),
            textView.topAnchor.constraint(equalTo: topAnchor, constant: edgeInsets.top),
            textView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -edgeInsets.bottom)
        ])
        
        NSLayoutConstraint.activate([
            sendButton.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 15),
            sendButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -buttonBottomInset),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -edgeInsets.right),
            sendButton.widthAnchor.constraint(equalToConstant: buttonSize.width),
            sendButton.heightAnchor.constraint(equalToConstant: buttonSize.height)
        ])
        
        textView.delegate = self
        
        pollButton.addTarget(self, action: #selector(onPollButtonTap), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(onSendButtonTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override var intrinsicContentSize: CGSize {
        let textSize = self.textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: self.bounds.width, height: textSize.height)
    }
    
    // MARK: - Actions
    
    @objc private func onPollButtonTap(_ sender: UIButton) {
        actions.createPoll()
    }
    
    @objc private func onSendButtonTap(_ sender: UIButton) {
        sendText()
    }
    
    private func sendText() {
        guard let text = textView.text else { return }
        
        actions.sendText(text)
        textView.text = nil
    }
}
