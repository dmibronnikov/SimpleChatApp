import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
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
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        
        return tableView
    }()
    private let chatInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        
        return view
    }()
    private let chatInputView: ChatInputView = ChatInputView()
    
    private var disableLayout: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        setupNavigationBar()
        setupTableView()
        
        view.addSubview(chatInputContainerView)
        chatInputContainerView.addSubview(chatInputView)
        chatInputView.actions = .init(
            sendText: actions.sendText,
            createPoll: actions.createPoll
        )
        
        setupKeyboardNotification()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard !disableLayout else { return }
        
        let inputContainerSize = CGSize(
            width: view.bounds.width,
            height: 95
        )
        chatInputContainerView.frame = CGRect(
            origin: CGPoint(x: 0, y: view.bounds.height - inputContainerSize.height),
            size: inputContainerSize
        )
        let inputSize = CGSize(
            width: inputContainerSize.width - 40,
            height: 40
        )
        chatInputView.frame = CGRect(
            origin: CGPoint(x: 20, y: 15),
            size: inputSize
        )
        
        let safeArea = view.safeAreaInsets
        tableView.frame = view.frame
        
        let contentInset = UIEdgeInsets(
            top: safeArea.bottom + chatInputView.frame.maxY,
            left: 0,
            bottom: safeArea.top,
            right: 0
        )
        tableView.contentInset = contentInset
        tableView.scrollIndicatorInsets = contentInset
    }
    
    // MARK: - Public
    
    func update() {
        tableView.reloadData()
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
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow(notification:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidHide(notification:)),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
    }
    
    // MARK: - Keyboard handling
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        disableLayout = true
        var inputContainerFrame = chatInputContainerView.frame
        inputContainerFrame.origin = CGPoint(x: 0, y: keyboardSize.minY - chatInputView.frame.maxY - 10)
        chatInputContainerView.frame = inputContainerFrame
        
        let topContentInset = view.bounds.height - inputContainerFrame.minY
        tableView.contentInset.top = topContentInset
        tableView.verticalScrollIndicatorInsets.top = topContentInset
        tableView.setContentOffset(CGPoint(x: 0, y: -tableView.contentInset.top), animated: false)
    }
    
    @objc private func keyboardDidShow(notification: NSNotification) {
        disableLayout = false
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        disableLayout = true
        let safeArea = view.safeAreaInsets
        var inputContainerFrame = chatInputContainerView.frame
        inputContainerFrame.origin = CGPoint(
            x: 0,
            y: view.bounds.height - inputContainerFrame.height
        )
        chatInputContainerView.frame = inputContainerFrame
        let topContentInset = view.bounds.height - inputContainerFrame.minY
        tableView.contentInset.top = topContentInset
        tableView.verticalScrollIndicatorInsets.top = topContentInset
    }
    
    @objc private func keyboardDidHide(notification: NSNotification) {
        disableLayout = false
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.messageIds().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
                textCell.transform = CGAffineTransform(scaleX: 1, y: -1)
                
                return textCell
            case .poll(let poll):
                let pollCell = tableView.dequeue(ChatPollCell.self, at: indexPath)
                pollCell.configure(messageId: message.id, poll: poll, sender: sender)
                pollCell.transform = CGAffineTransform(scaleX: 1, y: -1)
                
                return pollCell
        }
    }
}

