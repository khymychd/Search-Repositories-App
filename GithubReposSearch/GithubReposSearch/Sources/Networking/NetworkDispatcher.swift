import Foundation

// MARK: - HTTPMethod
enum HTTPMethod: String {
    case get, post, put, delete
    
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
protocol EndPoint {
    
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var query: [String: String]? { get }
    var payload: [AnyHashable: Any]? { get }
}

// MARK: - EndPoint + Default
extension EndPoint {
    
    var payloadData: Data? {
        guard let payload = payload else { return nil }
        return try? JSONSerialization.data(withJSONObject: payload, options: [])
    }
}

// MARK: - APIError
enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case forbidden
}

struct NetworkDispatcher<T: EndPoint> {
    
    let session: URLSession
    let baseURL: URL
    let decoder: JSONDecoder
    
    func dispatch<D: Decodable>(_ endPoint: T) async -> Result<D, APIError> {
        let request = createRequest(for: endPoint)
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            if httpResponse.statusCode ~= 200 {
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
        return request
    }
}
