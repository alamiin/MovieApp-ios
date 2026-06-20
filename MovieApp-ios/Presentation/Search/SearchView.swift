import SwiftUI

struct SearchView: View {
    @State var viewModel: SearchViewModel

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search movies...", text: Binding(
                    get: { viewModel.query },
                    set: { viewModel.queryChanged($0) }
                ))
                .submitLabel(.search)
                .onSubmit { viewModel.submit() }

                if !viewModel.query.isEmpty {
                    Button {
                        viewModel.clear()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(10)
            .background(Color.gray.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            .padding(.top, 8)

            if viewModel.query.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    Text("Search for movies")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.results.isEmpty && viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.results.isEmpty, let error = viewModel.errorMessage {
                LoadingErrorView(message: error) { viewModel.submit() }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.results.isEmpty && !viewModel.isLoading {
                VStack(spacing: 12) {
                    Image(systemName: "film.slash")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    Text("No results for \"\(viewModel.query)\"")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.results) { movie in
                            NavigationLink(value: movie) {
                                MoviePosterCard(movie: movie)
                            }
                            .buttonStyle(.plain)
                            .onAppear {
                                if movie == viewModel.results.last {
                                    viewModel.loadNextPage()
                                }
                            }
                        }
                    }
                    .padding()

                    if viewModel.isLoading {
                        ProgressView().padding()
                    }
                }
            }
        }
        .navigationTitle("Search")
    }
}
