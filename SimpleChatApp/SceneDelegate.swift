import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let navigationController = UINavigationController()
        let coordinator = ChatCoordinator(
            navigationController: navigationController,
            container: appDelegate.container
        )
        coordinator.start()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

