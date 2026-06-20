struct Movie: Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    let overview: String
    let posterUrl: String?
    let releaseDate: String?
    let voteAverage: Double?
}
