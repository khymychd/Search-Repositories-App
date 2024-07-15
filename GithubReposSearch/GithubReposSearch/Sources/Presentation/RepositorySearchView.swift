import SwiftUI

/// A view for displaying the results of a GitHub repository search.
struct RepositorySearchView: View {
    
    @ObservedObject var viewModel: RepositorySearchViewModel
    
    private let lineLimit: Int = 1
    private let minimumScaleFactor: CGFloat = 0.5
    private let cornerRadius: Double = 16
    private let shadowRadius: Double = 6
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.repositories, id: \.id) { repository in
                    HStack {
                        VStack(alignment: .leading) {
                            
                            Text(repository.fullName)
                                .font(.headline)
                                .minimumScaleFactor(minimumScaleFactor)
                            Text(repository.description ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .lineLimit(lineLimit)
                        Spacer()
                        InfoItemView(title: "stars".localized, value: "\(repository.stargazersCount)")
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(cornerRadius)
                    .shadow(radius: shadowRadius)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 4)
                    .onTapGesture {
                        viewModel.handleSelectRepo(repository)
                    }
                }
                if !viewModel.repositories.isEmpty, viewModel.hasMorePages {
                    Text("loading".localized)
                        .onAppear(perform: { viewModel.loadMoreIfCan() })
                }
            }
        }
        .background(content: {
            if viewModel.repositories.isEmpty {
                VStack {
                    Text("search_prompt".localized)
                    Text("search_minimum_characters".localized)
                }
                .font(.headline)
                .foregroundColor(.gray)
                .padding()
            }
        })
        .alert("search_alert_message".localized, isPresented: $viewModel.shouldDisplayAlert) {
            Button("ok".localized, role: .cancel) { }
        }
        .searchable(text: $viewModel.query)
        .task {
            viewModel.subscribeOnQueryChanges()
        }
    }
}
