final class ChatService {
    private let hostId = 4
    
    var modelUpdated: (() -> Void)?
    
    private(set) var messageIds = MockData.messageIds
    private(set) var content = MockData.content
    
    private var nextMessageId: Int {
        guard let lastId = messageIds.last else { return 1 }
        return lastId + 1
    }
    
    func sendText(_ text: String) {
        sendMessage(Message(id: nextMessageId, senderId: hostId, content: .text(text: text)))
    }
    
    func sendPoll(_ poll: Poll) {
        sendMessage(Message(id: nextMessageId, senderId: hostId, content: .poll(poll: poll)))
    }
    
    private func sendMessage(_ message: Message) {
        messageIds.append(message.id)
        content.addMessage(message)
        
        modelUpdated?()
    }
}

fileprivate enum MockData {
    static let messageIds: [Int] = {
        var ids: [Int] = []
        for i in 1..<10 {
            ids.append(i)
        }
        
        return ids
    }()
    
    static let content: Content = {
        var messages: [Int: Message] = [:]
        var users: [Int: User] = [:]
        
        var userIds: [Int] = [1, 2, 3]
        users[1] = User(id: 1, name: "Edwin", surname: "Bass")
        users[2] = User(id: 2, name: "Kelley", surname: "Hodges")
        users[3] = User(id: 3, name: "Jared", surname: "Phillips")
        users[4] = User(id: 4, name: "Dima", surname: "Bronnikov")
        
        for id in messageIds {
            let text = String(loremIpsum.prefix(Int.random(in: 20..<loremIpsum.count)))
            let senderId = userIds[Int.random(in: 0..<userIds.count)]
            let hasPoll = id == messageIds.last
            
            messages[id] = Message(
                id: id,
                senderId: senderId,
                content: hasPoll ? .poll(poll: poll) : .text(text: text)
            )
        }
        
        return Content(messages: messages, users: users)
    }()
    
    private static let poll: Poll = {
        let id = 1
        let options: [Poll.Option] = [
            .init(id: 1, text: "Los Angeles Lakers", votes: 0),
            .init(id: 2, text: "Golden State Warriors", votes: 0),
            .init(id: 3, text: "Chicago Bulls", votes: 0),
            .init(id: 2, text: "Boston Celtics", votes: 0)
        ]
        
        return Poll(id: id, question: "What is the greatest NBA team in history?", options: options)
    }()
    
    private static let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
}
