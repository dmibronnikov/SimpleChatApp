import UIKit

class ChatViewController: UITableViewController {
    struct Data {
        let messageIds: () -> [Int]
        let content: () -> Content
    }
    
    struct Actions {
        let createPoll: () -> Void
        let sendText: (_ text: String) -> Void
    }
    
    var data: Data!
    var actions: Actions!
    
    private lazy var chatAccessoryView: ChatAccessoryView = ChatAccessoryView()
    
    override var inputAccessoryView: UIView? { chatAccessoryView }
    
    override var canBecomeFirstResponder: Bool { true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        setupNavigationBar()
        setupTableView()
        
        chatAccessoryView.actions = .init(
            sendText: actions.sendText,
            createPoll: actions.createPoll
        )
        
        setupKeyboardNotification()
    }
    
    private func scrollToTop() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    // MARK: - Public
    
    func update() {
        tableView.reloadData()
        scrollToTop()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .lightBackground
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.titleView = ChatTitleView(title: "Lowkey Squad", subtitle: "1 member • 1 online")
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        
        tableView.keyboardDismissMode = .interactive
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        tableView.register(ChatTextCell.self)
        tableView.register(ChatPollCell.self)
    }
    
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: - Keyboard handling

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first!
        let safeArea = window.safeAreaInsets
        let contentInset = UIEdgeInsets(
            top: keyboardFrame.height,
            left: safeArea.left,
            bottom: safeArea.top + (navigationController?.navigationBar.bounds.height ?? 0),
            right: safeArea.right
        )
        tableView.contentInset = contentInset
        tableView.verticalScrollIndicatorInsets = contentInset
        if tableView.contentOffset.y <= 0 {
            scrollToTop()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset.top = chatAccessoryView.frame.height
        tableView.verticalScrollIndicatorInsets.top = chatAccessoryView.frame.height
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.messageIds().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageId = data.messageIds()[indexPath.row]
        let content = data.content()
        
        guard let message = content.messages[messageId] else {
            fatalError("Inconsistent data model. No message for id: \(messageId)")
        }
        guard let sender = content.users[message.senderId] else {
            fatalError("Inconsistent data model. No user for id: \(message.senderId)")
        }
        
        switch message.content {
            case .text(let text):
                let textCell = tableView.dequeue(ChatTextCell.self, at: indexPath)
                textCell.configure(messageId: message.id, text: text, sender: sender)
                
                return textCell
            case .poll(let poll):
                let pollCell = tableView.dequeue(ChatPollCell.self, at: indexPath)
                pollCell.configure(messageId: message.id, poll: poll, sender: sender)
                
                return pollCell
        }
    }
}
