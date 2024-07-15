import Foundation
import SwiftUI

/// A view for displaying the details of a GitHub repository.
struct RepositoryDetailsView: View {
    
    let repository: GitHubRepository
    
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
                    .fontWeight(.bold)
                    .lineLimit(lineLimit)
                    .minimumScaleFactor(minimumScaleFactor)
                    .padding(.bottom, bottomPadding)
                
                if let description = repository.description, !description.isEmpty {
                    Text(description)
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .padding(.bottom, bottomPadding)
                }
                
                HStack {
                    InfoItemView(title: "stars".localized, value: "\(repository.stargazersCount)")
                    Spacer()
                    InfoItemView(title: "issues".localized, value: "\(repository.openIssuesCount)")
                }
                .padding(.bottom, stackSpacing)
                
                HStack {
                    if let language = repository.language, !language.isEmpty {
                        InfoItemView(title: "Language", value: language)
                    }
                    Spacer()
                    DateInfoItemView(title: "Created At", value: repository.createdAt)
                }
                .padding(.bottom, stackSpacing)
                
                if let url = URL(string: repository.htmlUrl) {
                    Button(action: {
                        openURL(url)
                    }) {
                        Text("open_in_browser".localized)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(buttonPadding)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(viewPadding)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding()
        }
    }
}
