import UIKit
import SwiftUI

/// A class responsible for coordinating the navigation within the app.
class AppCoordinator {
    
    /// An enum representing the different screens that can be displayed.
    enum Screen {
        case repositorySearchList
        case repositoryDetail(for: GitHubRepository)
    }
    
    /// The navigation controller used for navigation.
    private var navigationController: UINavigationController
    
    /// The service provider used to obtain dependencies for view models.
    private let serviceProvider: ServiceProvider
    
    /// Initializes a new instance of `AppCoordinator`.
    ///
    /// - Parameters:
    ///   - navigationController: The navigation controller used for navigation.
    ///   - serviceProvider: The service provider used to obtain dependencies.
    init(navigationController: UINavigationController, serviceProvider: ServiceProvider) {
        self.navigationController = navigationController
        self.serviceProvider = serviceProvider
    }
    
    /// Displays the specified screen.
    ///
    /// - Parameter screen: The screen to be displayed.
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
