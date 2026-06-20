import SwiftUI

@main
struct MovieApp_iosApp: App {
    @State private var appViewModel = AppViewModel()
    private let repository: any MovieRepository = MovieRepositoryImpl()

    var body: some Scene {
        WindowGroup {
            AppRootView(repository: repository)
                .environment(appViewModel)
                .preferredColorScheme(appViewModel.themeMode.colorScheme)
        }
    }
}
