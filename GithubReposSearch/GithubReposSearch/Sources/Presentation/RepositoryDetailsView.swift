import Foundation
import SwiftUI

/// A view for displaying the details of a GitHub repository.
struct RepositoryDetailsView: View {
    
    let repository: GithubRepository
    
    @Environment(\.openURL) var openURL
    
    private let stackSpacing: CGFloat = 12.0
    private let lineLimit: Int = 1
    private let minimumScaleFactor: CGFloat = 0.7
    private let bottomPadding: CGFloat = 16.0
    private let buttonPadding: CGFloat = 8.0
    private let viewPadding: CGFloat = 16.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: stackSpacing) {
                Text(repository.fullName)
                    .font(.largeTitle)
                    .lineLimit(lineLimit)
                    .minimumScaleFactor(minimumScaleFactor)
                    .padding(.bottom, bottomPadding)
                
                Text(repository.description ?? "")
                    .font(.title2)
                
                HStack {
                    Text("stars".localized(with: "\(repository.stargazersCount)"))
                    Spacer()
                    Text("issues".localized(with: "\(repository.openIssuesCount)"))
                }
                
                HStack {
                    Text(repository.language ?? "")
                    Spacer()
                    Text(repository.createdAt, style: .date)
                }
                
                if let url = URL(string: repository.htmlUrl) {
                    Button(action: {
                        openURL(url)
                    }, label: {
                        Text("open_in_browser".localized)
                            .padding(buttonPadding)
                    })
                }
            }
            .padding(viewPadding)
        }
    }
}
