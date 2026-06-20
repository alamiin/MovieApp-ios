import Foundation

@Observable
final class SearchViewModel {
    var query = ""
    var results: [Movie] = []
    var isLoading = false
    var errorMessage: String?

    private var page = 1
    private var endReached = false
    private var searchTask: Task<Void, Never>?

    private let searchMovies: SearchMoviesUseCase

    init(searchMovies: SearchMoviesUseCase) {
        self.searchMovies = searchMovies
    }

    func queryChanged(_ newQuery: String) {
        query = newQuery
        guard !newQuery.trimmingCharacters(in: .whitespaces).isEmpty else {
            clear()
            return
        }
        scheduleSearch(query: newQuery, debounce: true)
    }

    func submit() {
        let q = query.trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { return }
        scheduleSearch(query: q, debounce: false)
    }

    func clear() {
        searchTask?.cancel()
        query = ""
        results = []
        errorMessage = nil
        page = 1
        endReached = false
        isLoading = false
    }

    func loadNextPage() {
        guard !isLoading && !endReached else { return }
        let q = query.trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { return }
        appendPage(query: q)
    }

    private func scheduleSearch(query: String, debounce: Bool) {
        searchTask?.cancel()
        results = []
        page = 1
        endReached = false
        errorMessage = nil

        searchTask = Task {
            if debounce {
                try? await Task.sleep(for: .milliseconds(350))
                guard !Task.isCancelled else { return }
            }
            guard query == self.query.trimmingCharacters(in: .whitespaces) else { return }
            await performSearch(query: query, page: 1, append: false)
        }
    }

    private func appendPage(query: String) {
        let nextPage = page
        isLoading = true
        Task {
            await performSearch(query: query, page: nextPage, append: true)
        }
    }

    private func performSearch(query: String, page: Int, append: Bool) async {
        isLoading = true
        do {
            let movies = try await searchMovies.execute(query: query, page: page)
            guard query == self.query.trimmingCharacters(in: .whitespaces) else { return }
            if movies.isEmpty {
                endReached = true
            } else {
                if append {
                    let existingIds = Set(results.map { $0.id })
                    let deduped = movies.filter { !existingIds.contains($0.id) }
                    results.append(contentsOf: deduped)
                } else {
                    results = movies
                }
                self.page = page + 1
                if movies.count < 10 { endReached = true }
            }
            errorMessage = nil
        } catch {
            if query == self.query.trimmingCharacters(in: .whitespaces) {
                errorMessage = error.localizedDescription
            }
        }
        isLoading = false
    }
}
