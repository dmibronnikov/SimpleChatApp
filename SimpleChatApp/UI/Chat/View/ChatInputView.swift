import UIKit

final class ChatInputView: UIView, UITextFieldDelegate {
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
    private let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .lightBackground
        textField.attributedPlaceholder = NSAttributedString(
            string: "Message",
            attributes: [
                .foregroundColor: UIColor.textSecondary,
                .font: UIFont.appFont(size: 15, weight: .regular)
            ]
        )
        textField.textColor = .textPrimary
        textField.font = .appFont(size: 15, weight: .regular)
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 15, height: 0)))
        textField.leftViewMode = .always
        textField.returnKeyType = .send
        
        return textField
    }()
    private let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [pollButton, textField, sendButton].forEach { addSubview($0) }
        
        textField.delegate = self
        
        sendButton.addTarget(self, action: #selector(onSendButtonTap), for: .touchUpInside)
        pollButton.addTarget(self, action: #selector(onPollButtonTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonSize = CGSize(width: 24, height: 24)
        let pollButtonFrame = CGRect(
            x: 0,
            y: (bounds.height - buttonSize.height) / 2,
            width: buttonSize.width,
            height: buttonSize.height
        )
        
        let textFieldWidth = bounds.width - buttonSize.width * 2 - 10 * 2
        let textFieldFrame = CGRect(
            x: pollButtonFrame.maxX + 10,
            y: (bounds.height - 35) / 2,
            width: textFieldWidth,
            height: 35
        )
        
        let sendButtonFrame = CGRect(
            x: textFieldFrame.maxX + 10,
            y: (bounds.height - buttonSize.height) / 2,
            width: buttonSize.width,
            height: buttonSize.height
        )
        
        pollButton.frame = pollButtonFrame
        textField.frame = textFieldFrame
        sendButton.frame = sendButtonFrame
    }
    
    // MARK: - Actions
    
    @objc private func onPollButtonTap(_ sender: UIButton) {
        actions.createPoll()
    }
    
    @objc private func onSendButtonTap(_ sender: UIButton) {
        sendText()
    }
    
    private func sendText() {
        guard let text = textField.text else { return }
        
        actions.sendText(text)
        textField.text = nil
        textField.resignFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendText()
        return true
    }
}
