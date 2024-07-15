import UIKit
import SwiftUI

class ServiceProvider {
    
    lazy var apiService: GithubApiClient = .init()
    
    func provideRepositoryViewModel(with coordinator: AppCoordinator) -> RepositorySearchViewModel {
        let dependencies: RepositorySearchViewModel.Dependencies = .init(
            apiClient: apiService,
            coordinator: coordinator)
        return .init(dependency: dependencies)
    }
}

class AppCoordinator {
    
    enum Screen {
        case repositorySearchList
        case repositoryDetail(for: GithubRepository)
    }

    private var navigationController: UINavigationController
    private let serviceProvider: ServiceProvider
    
    init(navigationController: UINavigationController, serviceProvider: ServiceProvider) {
        self.navigationController = navigationController
        self.serviceProvider = serviceProvider
    }
    
    func display(screen: Screen) {
        switch screen {
        case .repositorySearchList:
            let viewModel: RepositorySearchViewModel = serviceProvider.provideRepositoryViewModel(with: self)
            let hostingController = UIHostingController(rootView: RepositorySearchView(viewModel: viewModel))
            navigationController.setViewControllers([hostingController], animated: false)
        case .repositoryDetail(let repository):
            let hostingController = UIHostingController(rootView: RepositoryDetailsView(repository: repository))
            navigationController.pushViewController(hostingController, animated: true)
        }
    }
}
