import Foundation

@Observable
final class PopularViewModel {
    var movies: [Movie] = []
    var isLoading = false
    var errorMessage: String?

    private var page = 1
    private var endReached = false
    private var loadTask: Task<Void, Never>?

    private let getPopularMovies: GetPopularMoviesUseCase

    init(getPopularMovies: GetPopularMoviesUseCase) {
        self.getPopularMovies = getPopularMovies
    }

    func loadFirstPage() {
        loadTask?.cancel()
        movies = []
        page = 1
        endReached = false
        errorMessage = nil
        loadPage()
    }

    func loadNextPage() {
        guard !isLoading && !endReached else { return }
        loadPage()
    }

    private func loadPage() {
        let currentPage = page
        isLoading = true
        loadTask = Task {
            do {
                let newMovies = try await getPopularMovies.execute(page: currentPage)
                guard !Task.isCancelled else { return }
                if newMovies.isEmpty {
                    endReached = true
                } else {
                    let existingIds = Set(movies.map { $0.id })
                    let deduped = newMovies.filter { !existingIds.contains($0.id) }
                    movies.append(contentsOf: deduped)
                    page += 1
                    if newMovies.count < 10 { endReached = true }
                }
                errorMessage = nil
            } catch {
                guard !Task.isCancelled else { return }
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
