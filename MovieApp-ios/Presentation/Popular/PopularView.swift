import SwiftUI

struct PopularView: View {
    @State var viewModel: PopularViewModel

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        Group {
            if viewModel.movies.isEmpty && viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.movies.isEmpty, let error = viewModel.errorMessage {
                LoadingErrorView(message: error, onRetry: viewModel.loadFirstPage)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.movies) { movie in
                            NavigationLink(value: movie) {
                                MoviePosterCard(movie: movie)
                            }
                            .buttonStyle(.plain)
                            .onAppear {
                                if movie == viewModel.movies.last {
                                    viewModel.loadNextPage()
                                }
                            }
                        }
                    }
                    .padding()

                    if viewModel.isLoading {
                        ProgressView().padding()
                    }

                    if let error = viewModel.errorMessage, !viewModel.movies.isEmpty {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding()
                    }
                }
                .refreshable { viewModel.loadFirstPage() }
            }
        }
        .navigationTitle("Popular")
        .task { viewModel.loadFirstPage() }
    }
}
