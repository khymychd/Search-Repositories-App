import Foundation

/// Protocol defining the requirements for an API endpoint.
protocol EndPoint {
  
  /// The path of the endpoint.
  var path: String { get }
  
  /// The HTTP method used for the request.
  var method: HTTPMethod { get }
  
  /// The headers included in the request.
  var headers: [String: String] { get }
  
  /// The query parameters included in the request.
  var query: [String: String]? { get }
  
  /// The payload data included in the request.
  var payload: [AnyHashable: Any]? { get }
}

// MARK: - EndPoint + Default
extension EndPoint {
  
  /// Converts the payload dictionary into Data.
  ///
  /// - Returns: The payload data, or nil if the payload is nil or serialization fails.
  var payloadData: Data? {
    guard let payload = payload else { return nil }
    return try? JSONSerialization.data(withJSONObject: payload, options: [])
  }
}
