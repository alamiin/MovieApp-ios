import Foundation

@Observable
final class MovieDetailsViewModel {
    var details: MovieDetails?
    var isLoading = false
    var errorMessage: String?

    private let movieId: String
    private let getMovieDetails: GetMovieDetailsUseCase

    init(movieId: String, getMovieDetails: GetMovieDetailsUseCase) {
        self.movieId = movieId
        self.getMovieDetails = getMovieDetails
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            details = try await getMovieDetails.execute(movieId: movieId)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func retry() {
        Task { await load() }
    }
}
