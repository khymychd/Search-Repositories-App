import UIKit

/// An extension of `UISceneConfiguration` to provide a default configuration for scene sessions.
extension UISceneConfiguration {
  
  /// Creates a default scene configuration for the given session.
  ///
  /// - Parameter session: The scene session for which the configuration is being created.
  /// - Returns: A `UISceneConfiguration` instance with the name "Default Configuration" and the role of the given session.
  static func `default`(forSession session: UISceneSession) -> UISceneConfiguration {
    UISceneConfiguration(name: "Default Configuration", sessionRole: session.role)
  }
}
