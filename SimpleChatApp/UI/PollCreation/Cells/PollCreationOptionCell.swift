import UIKit

private let containerYInset: CGFloat = 4

final class PollCreationOptionCell: UITableViewCell, UITextFieldDelegate {
    static let height: CGFloat = 50 + containerYInset * 2
    
    struct Actions {
        let delete: () -> Void
        let textChanged: (_ text: String) -> Void
    }
    var actions: Actions!
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightBackground
        view.layer.cornerRadius = 15

        return view
    }()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Option",
            attributes: [
                .foregroundColor: UIColor.textSecondary,
                .font: UIFont.appFont(size: 15, weight: .regular)
            ]
        )
        textField.textColor = .textPrimary
        textField.font = .appFont(size: 15, weight: .regular)
        textField.returnKeyType = .done
        
        return textField
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .accent.withAlphaComponent(0.1)
        button.setImage(UIImage(named: "cancel_14"), for: .normal)
        button.tintColor = .textPrimary
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        [textField, deleteButton].forEach { containerView.addSubview($0) }
        
        containerView.clipsToBounds = true
        textField.delegate = self
        deleteButton.addTarget(self, action: #selector(onDeleteTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.frame = contentView.bounds
            .insetBy(dx: 20, dy: containerYInset)
        
        deleteButton.frame = containerView.bounds
            .divided(atDistance: containerView.frame.height, from: .maxXEdge).slice
        
        textField.frame = containerView.bounds
            .divided(atDistance: deleteButton.bounds.width, from: .maxXEdge).remainder
            .insetBy(dx: 15, dy: 15)
    }
    
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
    
    func configure(with text: String) {
        textField.text = text
    }
    
    @objc private func onDeleteTapped(_ sender: UIButton) {
        actions.delete()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        actions.textChanged(textField.text ?? "")
    }
}
