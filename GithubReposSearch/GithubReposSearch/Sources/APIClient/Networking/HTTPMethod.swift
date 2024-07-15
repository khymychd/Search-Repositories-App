import Foundation

/// Enum representing the different HTTP methods.
enum HTTPMethod: String {
  case get, post, put, delete
  
  /// Returns the raw value of the HTTP method as a string.
  var rawValue: String {
    switch self {
    case .get: return "GET"
    case .post: return "POST"
    case .put: return "PUT"
    case .delete: return "DELETE"
    }
  }
}
