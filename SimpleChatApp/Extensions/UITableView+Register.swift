import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ type: T.Type) {
        let identifier = String(describing: type)
        self.register(type, forCellReuseIdentifier: identifier)
    }
    
    func dequeue<T: UITableViewCell>(_ type: T.Type, at indexPath: IndexPath) -> T {
        let identifier = String(describing: type)
        return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }
}

