import Foundation

// MARK: - HTTPMethod
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

// MARK: - EndPoint
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

// MARK: - APIError
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
/// A struct responsible for dispatching network requests.
struct NetworkDispatcher<T: EndPoint> {
  
  /// The URL session used for network requests.
  let session: URLSession
  
  /// The base URL for the API.
  let baseURL: URL
  
  /// The JSON decoder used for decoding responses.
  let decoder: JSONDecoder
  
  /// Dispatches a network request for the given endpoint.
  ///
  /// - Parameter endPoint: The endpoint to be requested.
  /// - Returns: A result containing either the decoded response or an API error.
  func dispatch<D: Decodable>(_ endPoint: T) async -> Result<D, APIError> {
    let request = createRequest(for: endPoint)
    do {
      let (data, response) = try await session.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse else {
        return .failure(.invalidResponse)
      }
      if (200...299).contains(httpResponse.statusCode) {
        do {
          let decodedResponse = try decoder.decode(D.self, from: data)
          return .success(decodedResponse)
        } catch {
          return .failure(.decodingError(error))
        }
      } else if httpResponse.statusCode == 403 {
        return .failure(.forbidden)
      }
      return .failure(.invalidResponse)
      
    } catch {
      return .failure(.requestFailed(error))
    }
  }
  
  /// Creates a URL request for the given endpoint.
  ///
  /// - Parameter endPoint: The endpoint for which to create the request.
  /// - Returns: The created URL request.
  func createRequest(for endPoint: T) -> URLRequest {
    var url = baseURL.appending(path: endPoint.path)
    if let query = endPoint.query {
      let queryItems: [URLQueryItem] = query.map { .init(name: $0.key, value: $0.value) }
      url.append(queryItems: queryItems)
    }
    var request = URLRequest(url: url)
    request.httpMethod = endPoint.method.rawValue
    if !endPoint.headers.isEmpty {
      endPoint.headers.forEach {
        request.setValue($0.value, forHTTPHeaderField: $0.key)
      }
    }
    request.httpBody = endPoint.payloadData
    return request
  }
}
