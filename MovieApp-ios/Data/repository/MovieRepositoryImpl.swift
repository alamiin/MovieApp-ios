import Foundation

final class MovieRepositoryImpl: MovieRepository {
    private let service = OmdbService()
    private let featuredQuery = "batman"

    func getPopularMovies(page: Int) async throws -> [Movie] {
        try await searchInternal(query: featuredQuery, page: page)
    }

    func searchMovies(query: String, page: Int) async throws -> [Movie] {
        try await searchInternal(query: query, page: page)
    }

    func getMovieDetails(movieId: String) async throws -> MovieDetails {
        let dto = try await service.getMovieDetails(imdbId: movieId)
        try dto.ensureSuccess()
        return dto.toDomain()
    }

    private func searchInternal(query: String, page: Int) async throws -> [Movie] {
        let dto = try await service.searchMovies(query: query, page: page)
        try dto.ensureSuccess()
        let items = dto.search ?? []
        var seen = Set<String>()
        return items
            .filter { !$0.imdbID.isEmpty }
            .filter { item in seen.insert(item.imdbID).inserted }
            .map { item in item.toDomain() }
    }
}
