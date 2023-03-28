import UIKit

class ChatViewController: UIViewController {

    private let label: UILabel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Hello, world!"
        label.textColor = .systemRed
        view.addSubview(label)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        label.sizeToFit()
        label.center = view.center
    }
}

