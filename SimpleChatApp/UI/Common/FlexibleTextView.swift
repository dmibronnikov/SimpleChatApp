import UIKit

class FlexibleTextView: UITextView {
    var maxHeight: CGFloat = 0.0
    
    var attributedPlaceholder: NSAttributedString? {
        didSet {
            updatePlaceholder()
        }
    }
    
    var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    var placeholderTextColor: UIColor = .gray {
        didSet {
            updatePlaceholder()
        }
    }
    
    private var bodyTextColor: UIColor? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override var textColor: UIColor? {
        get {
            return bodyTextColor
        }
        set {
            bodyTextColor = newValue
        }
    }
    
    private var displayPlaceholder: Bool = true {
        didSet {
            updatePlaceholder()
        }
    }
    
    override var text: String! {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var font: UIFont? {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        
        if size.height == UIView.noIntrinsicMetric {
            layoutManager.glyphRange(for: textContainer)
            size.height = layoutManager.usedRect(for: textContainer).height + textContainerInset.top + textContainerInset.bottom
        }
        
        if maxHeight > 0.0 && size.height > maxHeight {
            size.height = maxHeight
            
            if !isScrollEnabled {
                isScrollEnabled = true
            }
        } else if isScrollEnabled {
            isScrollEnabled = false
        }
        
        return size
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        isScrollEnabled = false
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupNotifications()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textViewDidChange),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textViewDidBeginEditing),
            name: UITextView.textDidBeginEditingNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textViewDidEndEditing),
            name: UITextView.textDidEndEditingNotification,
            object: nil
        )
    }
    
    private func updatePlaceholder() {
        if displayPlaceholder {
            if let attributedPlaceholder = attributedPlaceholder {
                attributedText = attributedPlaceholder
            } else {
                super.textColor = placeholderTextColor
                text = placeholder
            }
        } else {
            text = ""
            super.textColor = bodyTextColor
        }
    }
    
    // MARK: - UITextViewDelegate notifications
    
    @objc private func textViewDidBeginEditing(_ notification: Notification) {
        if displayPlaceholder {
            displayPlaceholder = false
        }
    }
    
    @objc private func textViewDidEndEditing(_ notification: Notification) {
        if text == "" {
            displayPlaceholder = true
        }
    }
    
    @objc private func textViewDidChange(_ notification: Notification) {
        invalidateIntrinsicContentSize()
    }
}
