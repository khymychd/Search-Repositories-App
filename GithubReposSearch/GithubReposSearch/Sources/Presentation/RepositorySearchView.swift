import SwiftUI

/// A view for displaying the results of a GitHub repository search.
struct RepositorySearchView: View {
    
    @ObservedObject var viewModel: RepositorySearchViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.repositories, id: \.id) { repository in
                HStack {
                    VStack(alignment: .leading) {
                        Group {
                            Text(repository.fullName)
                            Text(repository.description ?? "")
                        }
                        .lineLimit(1)
                    }
                    Spacer()
                    Text("stars".localized(with: "\(repository.stargazersCount)"))
                }
                .onTapGesture {
                    viewModel.handleSelectRepo(repository)
                }
            }
            
            if !viewModel.repositories.isEmpty, viewModel.hasMorePages {
                Text("loading".localized)
                    .onAppear(perform: { viewModel.loadMoreIfCan() })
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
        .listStyle(PlainListStyle())
        .task {
            viewModel.subscribeOnQueryChanges()
        }
    }
}
