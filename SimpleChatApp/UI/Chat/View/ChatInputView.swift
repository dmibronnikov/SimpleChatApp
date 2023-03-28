import UIKit

final class ChatInputView: UIView, UITextFieldDelegate {
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
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 15, height: 0)))
        textField.leftViewMode = .always
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
