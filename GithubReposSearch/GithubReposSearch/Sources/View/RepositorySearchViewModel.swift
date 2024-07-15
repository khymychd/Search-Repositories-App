import Combine
import Foundation

class RepositorySearchViewModel: ObservableObject {
    
    struct Dependencies {
        let apiClient: GithubApiClient
        let coordinator: AppCoordinator
    }
    
    @Published var query: String = ""
    @Published var repositories: [GithubRepository] = []
    @Published var shouldDisplayAlert: Bool = false
    
    private var querySubscription: AnyCancellable?
    
    private var currentTask: Task<Void, Never>?
    
    private let debounceInterval: DispatchQueue.SchedulerTimeType.Stride = .seconds(0.5)
    
    let numberOfElementsPerPage: Int = 10
    private var currentPage: Int = 1
    private var totalCount: Int = 0
    
    let apiClient: GithubApiClient
    let coordinator: AppCoordinator
    
    init(dependency: Dependencies) {
        self.apiClient = dependency.apiClient
        self.coordinator = dependency.coordinator
    }
    
    deinit {
        currentTask?.cancel()
    }
    
    func subscribeOnQueryChanges() {
        if querySubscription != nil {
            return
        }
        querySubscription = $query
            .removeDuplicates()
            .debounce(for: debounceInterval, scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] searchQuery in
                guard let self else { return }
                self.currentTask?.cancel()
                if searchQuery.isEmpty {
                    DispatchQueue.main.async {
                        self.repositories = []
                        self.currentPage = 1
                        self.totalCount = 0
                    }
                    return
                }
                guard searchQuery.count >= 3 else {
                    return
                }
                self.currentTask = Task(operation: { @MainActor in
                    if Task.isCancelled { return }
                    let dataFetchResult = await self.apiClient.findRepositories(
                        by: searchQuery,
                        numberElementsPerPage: self.numberOfElementsPerPage,
                        currentPage: self.currentPage
                    )
                    switch dataFetchResult {
                    case .success(let successResult):
                        self.totalCount = successResult.totalCount
                        self.repositories = successResult.items
                    case .failure(let apiError):
                        self.handleError(apiError)
                    }
                })
            })
    }
    
    func loadMoreIfCan() {
        guard repositories.count < totalCount else {
            return
        }
        currentPage += 1
        currentTask = Task(operation: { @MainActor [weak self]  in
            guard let self else { return }
            if Task.isCancelled { return }
            let dataFetchResult = await self.apiClient.findRepositories(
                by: self.query,
                numberElementsPerPage: numberOfElementsPerPage,
                currentPage: currentPage
            )
            switch dataFetchResult {
            case .success(let successResult):
                self.repositories += successResult.items
            case .failure(let apiError):
                self.handleError(apiError)
            }
        })
    }
    
    func handleSelectRepo(_ repository: GithubRepository) {
        coordinator.display(screen: .repositoryDetail(for: repository))
    }
    
    private func handleError(_ error: APIError) {
        if case .forbidden = error {
            shouldDisplayAlert = true
        }
    }
}
