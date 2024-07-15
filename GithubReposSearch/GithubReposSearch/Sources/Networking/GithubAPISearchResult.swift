import Foundation

// MARK: - GithubSearchResult
struct GithubSearchResult: Decodable {
    let totalCount: Int
    let items: [GithubRepository]
}

struct GithubRepository: Decodable, Identifiable {
    let id: Int
    let name: String
    let fullName: String
    let htmlUrl: String
    let description: String?
    let language: String?
    let createdAt: Date
    let openIssuesCount: Int
    let stargazersCount: Int
}
