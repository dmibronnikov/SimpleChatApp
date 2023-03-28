import Foundation

struct User {
    let id: Int
    let name: String
    let surname: String
    
    var username: String { "\(name) \(surname)" }
}
