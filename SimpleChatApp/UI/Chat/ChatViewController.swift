import UIKit

private let poll: Poll = Poll(id: 1, question: "What is the greatest NBA team in the history?", options: [
    Poll.Option(id: 1, text: "Los Angeles Lakers", votes: 0),
    Poll.Option(id: 1, text: "Golden State Warriors", votes: 0),
    Poll.Option(id: 1, text: "Chicago Bulls", votes: 0),
    Poll.Option(id: 1, text: "Boston Celtics", votes: 0)
])

private let messages: [Message] = [
    Message(id: 1, senderId: 1, content: .text(text: "Sounds good to me!")),
    Message(id: 2, senderId: 2, content: .text(text: "Nice! 12 ppl in total. Let’s gather at the metro station!🚆🚆🚆")),
    Message(id: 3, senderId: 3, content: .text(text: "Okie dokie!!")),
    Message(id: 4, senderId: 2, content: .poll(poll: poll))
]

private let users: [Int: User] = [
    1: User(id: 1, name: "Edwin", surname: "Bass"),
    2: User(id: 2, name: "Kelley", surname: "Hodges"),
    3: User(id: 3, name: "Jared", surname: "Philips")
]

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        setupNavigationBar()
        setupTableView()
    }
    
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
        
        tableView.register(ChatTextCell.self)
        tableView.register(ChatPollCell.self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let sender = users[message.senderId]!
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

