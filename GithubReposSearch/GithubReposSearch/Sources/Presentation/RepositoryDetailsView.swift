import Foundation
import SwiftUI

/// A view for displaying the details of a GitHub repository.
struct RepositoryDetailsView: View {
  
  /// The repository to display.
  let repository: GithubRepository
  
  /// An environment value that provides a way to open URLs.
  @Environment(\.openURL) var openURL
  
  // Constants for magic numbers
  private let spacing: CGFloat = 12.0
  private let lineLimit: Int = 1
  private let minimumScaleFactor: CGFloat = 0.7
  private let bottomPadding: CGFloat = 16.0
  private let buttonPadding: CGFloat = 8.0
  private let viewPadding: CGFloat = 16.0
  
  var body: some View {
    ScrollView {
      VStack(spacing: spacing) {
        // Display the full name of the repository.
        Text(repository.fullName)
          .font(.largeTitle)
          .lineLimit(lineLimit) // Limit the text to one line.
          .minimumScaleFactor(minimumScaleFactor) // Scale the text down if necessary.
          .padding(.bottom, bottomPadding) // Add bottom padding.
        
        // Display the description of the repository.
        Text(repository.description ?? "")
          .font(.title2)
        
        // Display the stargazers count and open issues count.
        HStack {
          Text("stars".localized(with: repository.stargazersCount))
          Spacer()
          Text("issues".localized(with: repository.openIssuesCount))
        }
        
        // Display the primary language and creation date of the repository.
        HStack {
          Text(repository.language ?? "")
          Spacer()
          Text(repository.createdAt, style: .date)
        }
        
        // Display a button to open the repository in a browser.
        if let url = URL(string: repository.htmlUrl) {
          Button(action: {
            openURL(url) // Open the URL in a browser.
          }, label: {
            Text("open_in_browser".localized)
              .padding(buttonPadding) // Add padding to the button.
          })
        }
      }
      .padding(viewPadding) // Add padding to the VStack.
    }
  }
}
