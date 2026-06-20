import SwiftUI

enum ThemeMode: String, CaseIterable {
    case system, light, dark

    var displayName: String {
        switch self {
        case .system: "System"
        case .light: "Light"
        case .dark: "Dark"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}

@Observable
final class AppViewModel {
    var themeMode: ThemeMode = .system {
        didSet { UserDefaults.standard.set(themeMode.rawValue, forKey: "themeMode") }
    }

    init() {
        if let raw = UserDefaults.standard.string(forKey: "themeMode"),
           let mode = ThemeMode(rawValue: raw) {
            themeMode = mode
        }
    }
}
