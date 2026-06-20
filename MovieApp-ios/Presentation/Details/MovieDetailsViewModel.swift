import Foundation

@Observable
final class MovieDetailsViewModel {
    var details: MovieDetails?
    var isLoading = false
    var errorMessage: String?

    private let movieId: String
    private let repository: any MovieRepository

    init(movieId: String, repository: any MovieRepository) {
        self.movieId = movieId
        self.repository = repository
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            details = try await repository.getMovieDetails(movieId: movieId)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func retry() {
        Task { await load() }
    }
}
