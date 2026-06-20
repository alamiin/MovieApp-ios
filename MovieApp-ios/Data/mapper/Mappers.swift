import Foundation

enum OmdbError: LocalizedError {
    case apiError(String)

    var errorDescription: String? {
        if case .apiError(let msg) = self { return msg }
        return nil
    }
}

extension OmdbSearchResponse {
    func ensureSuccess() throws {
        guard response.caseInsensitiveCompare("True") == .orderedSame else {
            throw OmdbError.apiError(error ?? "OMDb request failed")
        }
    }
}

extension OmdbMovieDetails {
    func ensureSuccess() throws {
        guard response.caseInsensitiveCompare("True") == .orderedSame else {
            throw OmdbError.apiError(error ?? "OMDb request failed")
        }
    }

    func toDomain() -> MovieDetails {
        MovieDetails(
            id: imdbID,
            title: title,
            overview: plot ?? "",
            posterUrl: validOmdbString(poster),
            releaseDate: released ?? year,
            runtimeMinutes: parseRuntime(runtime),
            genres: parseGenres(genre),
            voteAverage: parseDouble(imdbRating),
            voteCount: parseVoteCount(imdbVotes)
        )
    }
}

extension OmdbSearchItem {
    func toDomain() -> Movie {
        Movie(
            id: imdbID,
            title: title,
            overview: "",
            posterUrl: validOmdbString(poster),
            releaseDate: year,
            voteAverage: nil
        )
    }
}

private func validOmdbString(_ value: String?) -> String? {
    guard let v = value?.trimmingCharacters(in: .whitespaces),
          !v.isEmpty, v.lowercased() != "n/a" else { return nil }
    return v
}

private func parseDouble(_ value: String?) -> Double? {
    guard let v = validOmdbString(value) else { return nil }
    return Double(v)
}

private func parseVoteCount(_ value: String?) -> Int? {
    guard let v = value else { return nil }
    let digits = v.filter(\.isNumber)
    return digits.isEmpty ? nil : Int(digits)
}

private func parseRuntime(_ value: String?) -> Int? {
    guard let v = value else { return nil }
    return v.split(separator: " ").first.flatMap { Int($0) }
}

private func parseGenres(_ value: String?) -> [String] {
    guard let v = value else { return [] }
    return v.split(separator: ",")
        .map { $0.trimmingCharacters(in: .whitespaces) }
        .filter { !$0.isEmpty }
}
