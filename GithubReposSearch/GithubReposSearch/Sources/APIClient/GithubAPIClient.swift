import Foundation


/// A client for interacting with the GitHub API.
open class GithubApiClient {
    
    // MARK: - Properties
    /// The base URL for the GitHub API.
    let baseURL: URL
    
    /// The API token for authenticating requests.
    internal var token: String!
    
    /// A lazy-loaded dispatcher for handling search-related network requests.
    lazy var searchDispatcher: NetworkDispatcher<GithubSearchEndPoint> = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        let result: NetworkDispatcher<GithubSearchEndPoint> = .init(
            session: .shared,
            baseURL: baseURL,
            decoder: decoder
        )
        return result
    }()
    
    // MARK: - Initializer
    
    /// Initializes a new instance of `GithubApiClient`.
    ///
    /// - Parameters:
    ///   - baseURL: The base URL for the GitHub API. Defaults to "https://api.github.com".
    public init( baseURL: URL = URL(string: "https://api.github.com")!) {
        self.baseURL = baseURL
        getApiToken() // Retrieve the API token during initialization
    }
    
    // MARK: - Public Methods
    
    /// Searches for repositories on GitHub based on the provided query.
    ///
    /// - Parameters:
    ///   - query: The search query.
    ///   - numberElementsPerPage: The number of elements per page.
    ///   - currentPage: The current page number.
    /// - Returns: A result containing either the search result or an API error.
    internal func findRepositories(
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
    
    // MARK: - Private Methods
    
    /// Retrieves the API token from the Info.plist file.
    ///
    /// This method reads the Info.plist file from the main bundle and extracts the API token.
    /// If the token cannot be found or the file is not properly formatted, the app will crash with a fatal error.
    private func getApiToken() {
        guard
            let url = Bundle.main.url(forResource: "Info", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
            let token = plist["ApiKey"] as? String
        else {
            fatalError("Unable to retrieve API token from Info.plist")
        }
        self.token = token
    }
}
