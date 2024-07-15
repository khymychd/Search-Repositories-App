import UIKit

extension UISceneConfiguration {
    
    static func `default`(forSession session: UISceneSession) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: session.role)
    }
}
