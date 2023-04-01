import UIKit

final class ChatCoordinator {
    let navigationController: UINavigationController
    
    private let container: Container
    private weak var chatController: ChatViewController?
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
        self.container.chatService.modelUpdated = { [weak self] in
            self?.chatController?.update()
        }
    }
    
    func start() {
        let chatController = createChatController()
        navigationController.pushViewController(chatController, animated: false)
        
        self.chatController = chatController
    }
    
    private func createChatController() -> ChatViewController {
        let chatController = ChatViewController()
        chatController.data = .init(
            messageIds: { self.container.chatService.messageIds.reversed() },
            content: { self.container.chatService.content }
        )
        chatController.actions = .init(
            createPoll: { [unowned navigationController] in
                let pollCreationController = self.createPollCreationController()
                navigationController.present(UINavigationController(rootViewController: pollCreationController), animated: true)
            },
            sendText: { self.container.chatService.sendText($0) }
        )
        
        return chatController
    }
    
    private func createPollCreationController() -> PollCreationViewController {
        let pollCreationViewController = PollCreationViewController()
        pollCreationViewController.actions = .init(
            createPoll: { poll in
                self.container.chatService.sendPoll(poll)
            }
        )
        return pollCreationViewController
    }
}
