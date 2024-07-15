import Foundation

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
