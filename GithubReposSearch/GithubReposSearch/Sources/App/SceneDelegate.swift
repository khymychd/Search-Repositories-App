import UIKit
import SwiftUI

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var appCoordinator: AppCoordinator!
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        let serviceProvider = (UIApplication.shared.delegate as! AppDelegate).serviceProvider
        appCoordinator = .init(navigationController: navigationController, serviceProvider: serviceProvider)
        appCoordinator.display(screen: .repositorySearchList)
    }
}
