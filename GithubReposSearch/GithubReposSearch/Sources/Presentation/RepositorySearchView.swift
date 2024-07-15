import SwiftUI

/// A view for displaying the results of a GitHub repository search.
struct RepositorySearchView: View {
  
  /// The view model for managing the state and interactions of the view.
  @ObservedObject var viewModel: RepositorySearchViewModel
  
  var body: some View {
    List {
      // Loop through the repositories and display each one in a list item.
      ForEach(viewModel.repositories, id: \.id) { repository in
        HStack {
          VStack(alignment: .leading) {
            Group {
              Text(repository.fullName) // Display the full name of the repository.
              Text(repository.description ?? "") // Display the description or an empty string if nil.
            }
            .lineLimit(1) // Limit the text to one line.
          }
          Spacer()
          Text("stars".localized(with: repository.stargazersCount)) // Display the stargazer count with a star icon.
        }
        .onTapGesture {
          viewModel.handleSelectRepo(repository) // Handle the repository selection.
        }
      }
      
      // Display a loading indicator when there are more repositories to load.
      if !viewModel.repositories.isEmpty {
        Text("loading".localized)
          .onAppear(perform: { viewModel.loadMoreIfCan() }) // Load more repositories when this text appears.
      }
    }
    .background(content: {
      // Display a prompt when the repository list is empty.
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
    // Display an alert with an important message.
    .alert("important_message".localized, isPresented: $viewModel.shouldDisplayAlert) {
      Button("ok".localized, role: .cancel) { }
    }
    // Add a search bar to the view.
    .searchable(text: $viewModel.query)
    // Use a plain list style.
    .listStyle(PlainListStyle())
    // Subscribe to query changes when the view appears.
    .task {
      viewModel.subscribeOnQueryChanges()
    }
  }
}
