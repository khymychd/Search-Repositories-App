import Foundation

/// A class responsible for providing services needed by view models.
final class ServiceProvider {
    
    /// A lazy-loaded instance of `GitHubApiClient` for API interactions.
    lazy var apiService: GitHubApiClient = .init()
}

// MARK: - Repository Search View Model
extension ServiceProvider {
    
    /// Provides a `RepositorySearchViewModel` instance with its dependencies.
    ///
    /// - Parameter coordinator: The coordinator responsible for navigation.
    /// - Returns: An instance of `RepositorySearchViewModel`.
    func provideRepositoryViewModel(with coordinator: AppCoordinator) -> RepositorySearchViewModel {
        let dependencies: RepositorySearchViewModel.Dependencies = .init(
            apiClient: apiService,
            coordinator: coordinator
        )
        return .init(dependency: dependencies)
    }
}
