import Foundation

class GithubApiClient {
    
    let baseURL: URL
    let session: URLSession
    private var token: String!
    
    lazy var searchDispatcher: NetworkDispatcher<GithubSearchEndPoint> = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        let result: NetworkDispatcher<GithubSearchEndPoint> = .init(
            session: session,
            baseURL: baseURL,
            decoder: decoder
        )
        return result
    }()
    
    init(
        baseURL: URL = URL(string: "https://api.github.com")!,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
        getApiToken()
    }
    
    func findRepositories(
        by query: String,
        numberElementsPerPage: Int,
        currentPage: Int
    ) async -> Result<GithubSearchResult, APIError> {
        
        let endPoint: GithubSearchEndPoint = .fetchRepositories(
            token: token,
            query: query,
            numberElementsPerPage: numberElementsPerPage,
            currentPage: currentPage
        )
        return await searchDispatcher.dispatch(endPoint)
    }
    
    private func getApiToken() {
        guard
            let url = Bundle.main.url(forResource: "Info", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
            let token = plist["ApiKey"] as? String
        else {
            fatalError()
        }
        self.token = token
    }
}
