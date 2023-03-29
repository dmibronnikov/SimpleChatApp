import UIKit

final class ChatCoordinator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let chatController = ChatViewController(with: self)
        navigationController.pushViewController(chatController, animated: false)
    }
}
