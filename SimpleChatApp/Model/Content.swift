struct Content {
    private(set) var messages: [Int: Message]
    private(set) var users: [Int: User]
    
    mutating func addMessage(_ message: Message) {
        messages[message.id] = message
    }
}
