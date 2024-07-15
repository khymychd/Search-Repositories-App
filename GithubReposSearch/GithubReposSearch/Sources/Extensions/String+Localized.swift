import Foundation

extension String {
  
  /// A computed property to return a localized string.
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
  
  /// A method to return a localized string with arguments.
  /// - Parameter arguments: The arguments to be inserted into the localized string.
  /// - Returns: A formatted localized string.
  func localized(with arguments: CVarArg...) -> String {
    return String(format: self.localized, arguments: arguments)
  }
}
