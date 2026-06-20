protocol MovieRepository {
    func getPopularMovies(page: Int) async throws -> [Movie]
    func searchMovies(query: String, page: Int) async throws -> [Movie]
    func getMovieDetails(movieId: String) async throws -> MovieDetails
}
