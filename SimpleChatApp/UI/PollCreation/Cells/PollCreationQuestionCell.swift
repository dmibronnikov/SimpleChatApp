import UIKit

private let placeholder: String = "Ask a question"

final class PollCreationQuestionCell: UITableViewCell, UITextViewDelegate {
    struct Actions {
        let textChanged: (String) -> Void
    }
    var actions: Actions!
    
    private var displayPlaceholder: Bool = true {
        didSet {
            updatePlaceholder()
        }
    }
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.backgroundColor = .lightBackground
        textView.layer.cornerRadius = 12
        textView.font = .appFont(size: 15, weight: .regular)
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 14, right: 10)
        textView.textColor = .textSecondary
        textView.text = placeholder
        
        return textView
    }()
    
    private var charactersLimit: Int?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(with charactersLimit: Int) {
        self.charactersLimit = charactersLimit
    }
    
    private func updatePlaceholder() {
        if displayPlaceholder {
            textView.textColor = .textSecondary
            textView.text = placeholder
        } else {
            textView.textColor = .textPrimary
            textView.text = ""
        }
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if displayPlaceholder {
            displayPlaceholder = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placeholder
            textView.textColor = .textSecondary
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let charactersLimit = charactersLimit else { return true }
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= charactersLimit
    }
    
    func textViewDidChange(_ textView: UITextView) {
        actions.textChanged(textView.text)
    }
}
