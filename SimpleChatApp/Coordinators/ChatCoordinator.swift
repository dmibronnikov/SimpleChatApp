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
            createPoll: {
                let pollCreationController = self.createPollCreationController()
                self.navigationController.present(pollCreationController, animated: true)
            },
            sendText: { self.container.chatService.sendText($0) }
        )
        
        return chatController
    }
    
    private func createPollCreationController() -> PollCreationViewController {
        return PollCreationViewController()
    }
}
