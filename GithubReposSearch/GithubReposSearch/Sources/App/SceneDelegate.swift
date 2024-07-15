import UIKit
import SwiftUI

/// The scene delegate, responsible for managing the app's UI scene lifecycle.
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  /// The window used to display the app's content.
  var window: UIWindow?
  
  /// The app coordinator responsible for handling navigation.
  var appCoordinator: AppCoordinator!
  
  /// Called when the scene is about to connect to the app session.
  ///
  /// - Parameters:
  ///   - scene: The scene object being connected to the app session.
  ///   - session: The session object containing details about the scene's role within the app.
  ///   - connectionOptions: Additional options for configuring the scene's connection.
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    // Ensure the scene is of type UIWindowScene.
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    // Create a new window for the window scene.
    let window = UIWindow(windowScene: windowScene)
    
    // Create a navigation controller and set it as the root view controller of the window.
    let navigationController = UINavigationController()
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    self.window = window
    
    // Retrieve the service provider from the app delegate.
    let serviceProvider = (UIApplication.shared.delegate as! AppDelegate).serviceProvider
    
    // Initialize the app coordinator with the navigation controller and service provider.
    appCoordinator = .init(navigationController: navigationController, serviceProvider: serviceProvider)
    
    // Display the initial screen (repository search list).
    appCoordinator.display(screen: .repositorySearchList)
  }
}
