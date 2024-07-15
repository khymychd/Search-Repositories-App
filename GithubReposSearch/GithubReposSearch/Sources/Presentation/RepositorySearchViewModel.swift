import Combine
import Foundation

/// A view model for managing the state and interactions of the repository search view.
class RepositorySearchViewModel: ObservableObject {
  
  /// A struct representing the dependencies required by the view model.
  struct Dependencies {
    let apiClient: GithubApiClient
    let coordinator: AppCoordinator
  }
  
  /// The search query entered by the user.
  @Published var query: String = ""
  
  /// The list of repositories matching the search query.
  @Published var repositories: [GithubRepository] = []
  
  /// A flag indicating whether an alert should be displayed.
  @Published var shouldDisplayAlert: Bool = false
  
  /// A subscription for the search query changes.
  private var querySubscription: AnyCancellable?
  
  /// The current task for fetching data.
  private var currentTask: Task<Void, Never>?
  
  /// The debounce interval for the search query.
  private let debounceInterval: DispatchQueue.SchedulerTimeType.Stride = .seconds(0.5)
  
  /// The number of elements to fetch per page.
  let numberOfElementsPerPage: Int = 10
  
  /// The current page number for pagination.
  private var currentPage: Int = 1
  
  /// The total number of repositories matching the search query.
  internal var totalCount: Int = 0
  
  /// The API client for interacting with the GitHub API.
  let apiClient: GithubApiClient
  
  /// The coordinator for handling navigation.
  let coordinator: AppCoordinator
  
  /// Initializes a new instance of `RepositorySearchViewModel` with the given dependencies.
  ///
  /// - Parameter dependency: The dependencies required by the view model.
  init(dependency: Dependencies) {
    self.apiClient = dependency.apiClient
    self.coordinator = dependency.coordinator
  }
  
  /// Cancels the current task when the view model is deinitialized.
  deinit {
    currentTask?.cancel()
  }
  
  /// Subscribes to changes in the search query and handles search logic.
  func subscribeOnQueryChanges() {
    if querySubscription != nil {
      return
    }
    querySubscription = $query
      .removeDuplicates() // Remove duplicate search queries.
      .debounce(for: debounceInterval, scheduler: DispatchQueue.main) // Debounce the search query.
      .sink(receiveValue: { [weak self] searchQuery in
        guard let self = self else { return }
        self.currentTask?.cancel() // Cancel any ongoing task.
        if searchQuery.isEmpty {
          DispatchQueue.main.async {
            self.repositories = [] // Clear the repositories list.
            self.currentPage = 1 // Reset the current page.
            self.totalCount = 0 // Reset the total count.
          }
          return
        }
        guard searchQuery.count >= 3 else {
          return
        }
        self.currentTask = Task { @MainActor in
          if Task.isCancelled { return }
          let dataFetchResult = await self.apiClient.findRepositories(
            by: searchQuery,
            numberElementsPerPage: self.numberOfElementsPerPage,
            currentPage: self.currentPage
          )
          switch dataFetchResult {
          case .success(let successResult):
            self.totalCount = successResult.totalCount // Update the total count.
            self.repositories = successResult.items // Update the repositories list.
          case .failure(let apiError):
            self.handleError(apiError) // Handle any errors.
          }
        }
      })
  }
  
  /// Loads more repositories if there are more to load.
  func loadMoreIfCan() {
    guard repositories.count < totalCount else {
      return
    }
    currentPage += 1
    currentTask = Task { @MainActor [weak self] in
      guard let self = self else { return }
      if Task.isCancelled { return }
      let dataFetchResult = await self.apiClient.findRepositories(
        by: self.query,
        numberElementsPerPage: self.numberOfElementsPerPage,
        currentPage: self.currentPage
      )
      switch dataFetchResult {
      case .success(let successResult):
        self.repositories += successResult.items // Append new repositories to the list.
      case .failure(let apiError):
        self.handleError(apiError) // Handle any errors.
      }
    }
  }
  
  /// Handles the selection of a repository.
  ///
  /// - Parameter repository: The selected repository.
  func handleSelectRepo(_ repository: GithubRepository) {
    coordinator.display(screen: .repositoryDetail(for: repository)) // Navigate to the repository detail screen.
  }
  
  /// Handles API errors.
  ///
  /// - Parameter error: The API error to handle.
  private func handleError(_ error: APIError) {
    if case .forbidden = error {
      shouldDisplayAlert = true // Display an alert if the error is forbidden.
    }
  }
}
