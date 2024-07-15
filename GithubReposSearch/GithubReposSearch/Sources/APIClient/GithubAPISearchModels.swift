import Foundation

// MARK: - GithubSearchResult
/// A struct representing the result of a GitHub repository search.
struct GithubSearchResult: Decodable {
  
  /// The total number of repositories found.
  let totalCount: Int
  
  /// The list of repositories matching the search criteria.
  let items: [GithubRepository]
}

// MARK: - GithubRepository
/// A struct representing a GitHub repository.
struct GithubRepository: Decodable, Identifiable {
  
  /// The unique identifier of the repository.
  let id: Int
  
  /// The name of the repository.
  let name: String
  
  /// The full name of the repository, including the owner.
  let fullName: String
  
  /// The URL of the repository on GitHub.
  let htmlUrl: String
  
  /// The description of the repository.
  let description: String?
  
  /// The primary language used in the repository.
  let language: String?
  
  /// The date when the repository was created.
  let createdAt: Date
  
  /// The number of open issues in the repository.
  let openIssuesCount: Int
  
  /// The number of stargazers (stars) the repository has.
  let stargazersCount: Int
}
