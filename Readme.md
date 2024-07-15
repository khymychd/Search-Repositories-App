# Search Repositories App

## Overview

- Display a search field and a list of found repositories on the search screen.
- Show minimal information in the repository list (name, short description, star count).
- Minimum search query length is 3 characters. Begin searching as soon as the user enters a valid query. Stop the previous search when a new query is entered using a debounce/throttle mechanism.
- Implement pagination for the search results.
- Display an appropriate error message when the GitHub API rate limit is reached.
- Open repository details on a separate screen when a repository in the list is clicked.
- Display the following information on the repository details screen: name, full description, star count, programming language, creation date, open issues count, and a button for direct navigation to the repository in the browser.

## Installation

1. Clone the repository:
```sh
git clone https://github.com/your-username/search-repositories-app.git
cd search-repositories-app
```
2. Open SearchRepositoriesApp.xcodeproj
3. Add your GitHub API key:
    - Open the Config\APIConfig file.
    - Replace placeholder on your GitHub API Key.

