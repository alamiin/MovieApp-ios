import SwiftUI

struct MoviePosterCard: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            AsyncImage(url: movie.posterUrl.flatMap { URL(string: $0) }) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(2/3, contentMode: .fill)
                case .failure, .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .aspectRatio(2/3, contentMode: .fill)
                        .overlay(Image(systemName: "film").font(.largeTitle).foregroundStyle(.secondary))
                @unknown default:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .aspectRatio(2/3, contentMode: .fill)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(movie.title)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(2)
                .foregroundStyle(.primary)

            if let rating = movie.voteAverage {
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(.yellow)
                    Text(String(format: "%.1f", rating))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
