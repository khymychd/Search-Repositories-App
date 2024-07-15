import SwiftUI

struct RepositorySearchView: View {
    
    @ObservedObject var viewModel: RepositorySearchViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.repositories, id: \.id) { repository in
                HStack {
                    VStack(alignment: .leading) {
                        Group {
                            Text(repository.fullName)
                            Text((repository.description ?? ""))
                        }
                        .lineLimit(1)
                    }
                    Spacer()
                    Text("⭐️ \(repository.stargazersCount)")
                }
                .onTapGesture {
                    viewModel.handleSelectRepo(repository)
                }
            }
            if !viewModel.repositories.isEmpty {
                Text("Loading...").onAppear(perform: { viewModel.loadMoreIfCan() })
            }
        }
        .background(content: {
            if viewModel.repositories.isEmpty {
                VStack {
                    Text("Please start typing in the search bar.")
                    Text("Minimum 3 characters.")
                }
                .font(.headline)
                .foregroundColor(.gray)
                .padding()
            }
        })
        .alert("Important message", isPresented: $viewModel.shouldDisplayAlert) {
                    Button("OK", role: .cancel) { }
                }
        .searchable(text: $viewModel.query)
        .listStyle(PlainListStyle())
        .task {
            viewModel.subscribeOnQueryChanges()
        }
    }
}
