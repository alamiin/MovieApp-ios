import Foundation

struct OmdbService {
    private static let apiKey = "49fba587"
    private static let baseURL = "https://www.omdbapi.com"

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        return d
    }()

    func searchMovies(query: String, page: Int) async throws -> OmdbSearchResponse {
        let url = try buildURL(params: [
            URLQueryItem(name: "s", value: query),
            URLQueryItem(name: "page", value: "\(page)"),
        ])
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decoder.decode(OmdbSearchResponse.self, from: data)
    }

    func getMovieDetails(imdbId: String) async throws -> OmdbMovieDetails {
        let url = try buildURL(params: [
            URLQueryItem(name: "i", value: imdbId),
            URLQueryItem(name: "plot", value: "full"),
        ])
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decoder.decode(OmdbMovieDetails.self, from: data)
    }

    private func buildURL(params: [URLQueryItem]) throws -> URL {
        var components = URLComponents(string: Self.baseURL)!
        components.queryItems = params + [URLQueryItem(name: "apikey", value: Self.apiKey)]
        guard let url = components.url else { throw URLError(.badURL) }
        return url
    }
}
