import UIKit

/// The main entry point of the application.
@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  
  /// The service provider for managing dependencies throughout the app.
  let serviceProvider: ServiceProvider = .init()
  
  /// Called when the application has finished launching.
  ///
  /// - Parameters:
  ///   - application: The singleton app object.
  ///   - launchOptions: A dictionary indicating the reason the app was launched (if any).
  /// - Returns: A boolean indicating whether the app successfully finished launching.
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    true
  }
  
  // MARK: - UISceneSession Lifecycle
  
  /// Called when a new scene session is being created.
  ///
  /// - Parameters:
  ///   - application: The singleton app object.
  ///   - connectingSceneSession: The scene session being created.
  ///   - options: Additional options for configuring the new scene.
  /// - Returns: The configuration to use when creating the new scene.
  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    .default(forSession: connectingSceneSession)
  }
}
