import Foundation

/// Enum representing the different types of API errors.
enum APIError: Error, Equatable {
  case invalidURL
  case requestFailed(Error)
  case invalidResponse
  case decodingError(Error)
  case forbidden
  
  static func ==(lhs: APIError, rhs: APIError) -> Bool {
    switch (lhs, rhs) {
    case (.invalidURL, .invalidURL),
      (.invalidResponse, .invalidResponse),
      (.forbidden, .forbidden):
      return true
    case (.requestFailed(let lError), .requestFailed(let rError)),
      (.decodingError(let lError), .decodingError(let rError)):
      return (lError as NSError).domain == (rError as NSError).domain &&
      (lError as NSError).code == (rError as NSError).code
    default:
      return false
    }
  }
}
