import UIKit

final class ChatCoordinator {
    let navigationController: UINavigationController
    
    private let chatService: ChatService
    private weak var chatController: ChatViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.chatService = ChatService()
        self.chatService.modelUpdated = { [weak self] in
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
            messageIds: { self.chatService.messageIds.reversed() },
            content: { self.chatService.content }
        )
        chatController.actions = .init(
            createPoll: {
                let pollCreationController = self.createPollCreationController()
                self.navigationController.present(pollCreationController, animated: true)
            },
            sendText: { self.chatService.sendText($0) }
        )
        
        return chatController
    }
    
    private func createPollCreationController() -> PollCreationViewController {
        return PollCreationViewController()
    }
}
