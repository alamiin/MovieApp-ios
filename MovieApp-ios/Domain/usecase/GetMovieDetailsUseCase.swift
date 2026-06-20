final class GetMovieDetailsUseCase {
    private let repository: any MovieRepository

    init(repository: any MovieRepository) {
        self.repository = repository
    }

    func execute(movieId: String) async throws -> MovieDetails {
        try await repository.getMovieDetails(movieId: movieId)
    }
}
