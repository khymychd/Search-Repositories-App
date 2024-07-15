import Foundation

enum GithubSearchEndPoint: EndPoint {
    
    case fetchRepositories(
        token: String,
        query: String,
        numberElementsPerPage: Int,
        currentPage: Int
    )
    
    var method: HTTPMethod {
        .get
    }
    
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
    
    var payload: [AnyHashable : Any]? {
        nil
    }
    
    var path: String {
        "/search/repositories"
    }
}
