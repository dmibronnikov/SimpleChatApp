import Foundation

struct Message {
    enum Content {
        case text(text: String)
        case poll(poll: Poll)
    }
    
    let id: Int
    let senderId: Int
    let content: Content
}
