final class SearchMoviesUseCase {
    private let repository: any MovieRepository

    init(repository: any MovieRepository) {
        self.repository = repository
    }

    func execute(query: String, page: Int) async throws -> [Movie] {
        try await repository.searchMovies(query: query, page: page)
    }
}
