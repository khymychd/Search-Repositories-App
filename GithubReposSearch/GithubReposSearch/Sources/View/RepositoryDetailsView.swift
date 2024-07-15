import Foundation
import SwiftUI

struct RepositoryDetailsView: View {
    
    let repository: GithubRepository
    @Environment(\.openURL) var openURL

    var body: some View {
        ScrollView {
            VStack(spacing: 12.0) {
                Text(repository.fullName)
                    .font(.largeTitle)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .padding(.bottom, 16.0)
                Text(repository.description  ?? "")
                    .font(.title2)
                
                HStack {
                    Text("⭐️ \(repository.stargazersCount)")
                    Spacer()
                    Text("Issues: \(repository.openIssuesCount)")
                }
                HStack {
                    Text(repository.language ?? "")
                    Spacer()
                    Text(repository.createdAt, style: .date)
                }

                if let url = URL(string:  repository.htmlUrl) {
                    Button(action: {
                        openURL(url)
                    }, label: {
                        Text("Open in Browser")
                            .padding()
                    })
                }
            }
            .padding()
        }
    }
}
