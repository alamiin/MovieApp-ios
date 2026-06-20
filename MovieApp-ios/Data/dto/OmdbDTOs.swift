import Foundation

struct OmdbSearchResponse: Decodable {
    let search: [OmdbSearchItem]?
    let response: String
    let error: String?

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case response = "Response"
        case error = "Error"
    }
}

struct OmdbSearchItem: Decodable {
    let title: String
    let year: String
    let imdbID: String
    let poster: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case poster = "Poster"
    }
}

struct OmdbMovieDetails: Decodable {
    let title: String
    let year: String?
    let released: String?
    let runtime: String?
    let genre: String?
    let plot: String?
    let poster: String?
    let imdbRating: String?
    let imdbVotes: String?
    let imdbID: String
    let response: String
    let error: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case plot = "Plot"
        case poster = "Poster"
        case imdbRating
        case imdbVotes
        case imdbID
        case response = "Response"
        case error = "Error"
    }
}
