import SwiftUI

struct MovieDetailsView: View {
    @State private var viewModel: MovieDetailsViewModel

    init(movie: Movie, repository: any MovieRepository) {
        _viewModel = State(initialValue: MovieDetailsViewModel(movieId: movie.id, repository: repository))
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.details == nil {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage, viewModel.details == nil {
                LoadingErrorView(message: error, onRetry: viewModel.retry)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let details = viewModel.details {
                detailsContent(details)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
    }

    @ViewBuilder
    private func detailsContent(_ details: MovieDetails) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                AsyncImage(url: details.posterUrl.flatMap { URL(string: $0) }) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .clipped()
                    default:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .overlay(Image(systemName: "film").font(.system(size: 60)).foregroundStyle(.secondary))
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text(details.title)
                        .font(.title2)
                        .fontWeight(.bold)

                    HStack(spacing: 16) {
                        if let date = details.releaseDate {
                            Label(date, systemImage: "calendar")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        if let runtime = details.runtimeMinutes {
                            Label("\(runtime) min", systemImage: "clock")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        if let rating = details.voteAverage {
                            Label(String(format: "%.1f", rating), systemImage: "star.fill")
                                .font(.subheadline)
                                .foregroundStyle(.yellow)
                        }
                    }

                    if !details.genres.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(details.genres, id: \.self) { genre in
                                    Text(genre)
                                        .font(.caption)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Color.accentColor.opacity(0.15), in: Capsule())
                                        .foregroundStyle(Color.accentColor)
                                }
                            }
                        }
                    }

                    if !details.overview.isEmpty {
                        Text(details.overview)
                            .font(.body)
                            .foregroundStyle(.primary)
                    }

                    if let voteCount = details.voteCount {
                        Text("\(voteCount) votes")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(details.title)
    }
}
