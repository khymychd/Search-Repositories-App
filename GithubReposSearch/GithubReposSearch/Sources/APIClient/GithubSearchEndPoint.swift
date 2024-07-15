import Foundation

/// An enum representing the various endpoints for GitHub search functionality.
enum GithubSearchEndPoint: EndPoint {
  
  /// Endpoint for fetching repositories based on a search query.
  case fetchRepositories(
    token: String,
    query: String,
    numberElementsPerPage: Int,
    currentPage: Int
  )
  
  /// The HTTP method for the endpoint. Always returns `.get` for search endpoints.
  var method: HTTPMethod {
    .get
  }
  
  /// The headers required for the request. Includes the Accept header and API version, with the Authorization header added for the fetchRepositories case.
  var headers: [String : String] {
    var result = [
      "Accept": "application/vnd.github+json",
      "X-GitHub-Api-Version": "2022-11-28"
    ]
    switch self {
    case .fetchRepositories(let token, _, _, _):
      result["Authorization"] = "Bearer \(token)"
    }
    return result
  }
  
  /// The query parameters for the request. Includes the search query, number of elements per page, and the current page number.
  var query: [String : String]? {
    switch self {
    case .fetchRepositories(_, let query, let numberElementsPerPage, let currentPage):
      return [
        "q": query,
        "per_page": "\(numberElementsPerPage)",
        "page" : "\(currentPage)"
      ]
    }
  }
  
  /// The payload for the request. Always returns nil as there is no payload for search endpoints.
  var payload: [AnyHashable : Any]? {
    nil
  }
  
  /// The path for the endpoint. Always returns the path for searching repositories.
  var path: String {
    "/search/repositories"
  }
}
