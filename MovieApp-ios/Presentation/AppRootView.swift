import SwiftUI

struct AppRootView: View {
    @Environment(AppViewModel.self) private var appViewModel
    @State private var popularVM: PopularViewModel
    @State private var searchVM: SearchViewModel

    private let repository: any MovieRepository

    init(repository: any MovieRepository) {
        self.repository = repository
        _popularVM = State(initialValue: PopularViewModel(repository: repository))
        _searchVM = State(initialValue: SearchViewModel(repository: repository))
    }

    var body: some View {
        TabView {
            Tab("Popular", systemImage: "film") {
                NavigationStack {
                    PopularView(viewModel: popularVM)
                        .navigationDestination(for: Movie.self) { movie in
                            MovieDetailsView(movie: movie, repository: repository)
                        }
                        .toolbar { themeMenu }
                }
            }
            Tab("Search", systemImage: "magnifyingglass") {
                NavigationStack {
                    SearchView(viewModel: searchVM)
                        .navigationDestination(for: Movie.self) { movie in
                            MovieDetailsView(movie: movie, repository: repository)
                        }
                        .toolbar { themeMenu }
                }
            }
        }
    }

    @ToolbarContentBuilder
    private var themeMenu: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Picker("Theme", selection: Binding(
                    get: { appViewModel.themeMode },
                    set: { appViewModel.themeMode = $0 }
                )) {
                    ForEach(ThemeMode.allCases, id: \.self) { mode in
                        Text(mode.displayName).tag(mode)
                    }
                }
            } label: {
                Image(systemName: "circle.lefthalf.filled")
            }
        }
    }
}
