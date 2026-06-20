final class GetPopularMoviesUseCase {
    private let repository: any MovieRepository

    init(repository: any MovieRepository) {
        self.repository = repository
    }

    func execute(page: Int) async throws -> [Movie] {
        try await repository.getPopularMovies(page: page)
    }
}
