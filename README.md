# MovieApp iOS

A SwiftUI movie browser app powered by the [OMDb API](https://www.omdbapi.com), built as an iOS port of the companion Android app. Browse popular movies, search by title, and view full details — all with dark/light theme support.

---

## Screenshots

| Popular | Search | Details |
|---------|--------|---------|
| Grid of popular movies with pull-to-refresh | Debounced search with paginated results | Full details: poster, genres, runtime, rating, plot |

---

## Features

- **Popular Movies** — Browse a curated list with infinite scroll and pull-to-refresh
- **Search** — Real-time search with 350 ms debounce and pagination
- **Movie Details** — Poster, release date, runtime, genres, IMDb rating, vote count, and full plot
- **Theme Switching** — System / Light / Dark mode, persisted across launches
- **Error Handling** — Retry button on all failure states

---

## Architecture

The app follows **Clean Architecture** with three layers, mirroring the Android counterpart.

```
MovieApp-ios/
├── Domain/                         # Pure Swift — no framework dependencies
│   ├── Movie.swift                 # Core movie model
│   ├── MovieDetails.swift          # Extended movie model (runtime, genres, votes)
│   ├── MovieRepository.swift       # Repository protocol
│   └── Resource.swift              # Generic state enum: loading / success / error
│
├── Data/                           # Networking & mapping
│   ├── OmdbDTOs.swift              # Decodable DTOs for OMDb API responses
│   ├── OmdbService.swift           # URLSession-based API client
│   ├── Mappers.swift               # DTO → domain model conversions + OmdbError
│   └── MovieRepositoryImpl.swift   # Concrete repository implementation
│
└── Presentation/                   # SwiftUI views + @Observable ViewModels
    ├── AppViewModel.swift          # Theme mode state (System/Light/Dark)
    ├── AppRootView.swift           # TabView root + NavigationStack per tab
    │
    ├── Popular/
    │   ├── PopularViewModel.swift  # Loads "batman" movies, handles pagination
    │   └── PopularView.swift       # LazyVGrid, infinite scroll, pull-to-refresh
    │
    ├── Search/
    │   ├── SearchViewModel.swift   # Debounced search, pagination, stale-guard
    │   └── SearchView.swift        # Search bar + results grid
    │
    ├── Details/
    │   ├── MovieDetailsViewModel.swift  # Loads single movie by IMDb ID
    │   └── MovieDetailsView.swift       # Full detail layout with scroll
    │
    └── Components/
        ├── MoviePosterCard.swift    # Reusable card (AsyncImage, title, rating)
        └── LoadingErrorView.swift   # Retry-able error state view
```

---

## Tech Stack

| Concern | Solution |
|---|---|
| UI Framework | SwiftUI |
| State Management | `@Observable` macro (Swift 5.9+) |
| Async/Concurrency | Swift `async/await`, structured `Task` |
| Networking | `URLSession` (no third-party libs) |
| Image Loading | SwiftUI `AsyncImage` |
| Theme Persistence | `UserDefaults` |
| Dependency Injection | Manual constructor injection |

No external dependencies — the project builds out of the box with no package manager setup.

---

## Data Flow

```
View  ──(user action)──▶  ViewModel  ──(async call)──▶  Repository
                               │                              │
                               │◀──── @Observable update ────│
                               │       (movies, isLoading,    │
                               │        errorMessage)         │
                                                         OmdbService
                                                         (URLSession)
                                                              │
                                                         OMDb API
                                                    https://www.omdbapi.com
```

### Key patterns

- **`@Observable` + `@State`** — ViewModels are declared as `@State var viewModel` in their owning view. SwiftUI automatically re-renders when observed properties change.
- **Pagination** — Views watch `.onAppear` on the last item in the grid; when it appears, `loadNextPage()` is called.
- **Search debounce** — A `Task` is created on each keystroke with `Task.sleep(for: .milliseconds(350))`. Typing a new character cancels the previous task before the sleep completes.
- **Stale-response guard** — After every await, the ViewModel checks whether `query` has changed before applying results.
- **Deduplication** — Incoming pages are filtered against a `Set` of already-loaded IMDb IDs before appending.

---

## API

The app uses the **OMDb API** (`https://www.omdbapi.com`).

| Endpoint | Usage |
|---|---|
| `?s=<query>&page=<n>&apikey=<key>` | Search / popular (fixed query: `batman`) |
| `?i=<imdbID>&plot=full&apikey=<key>` | Movie details |

The API key is embedded in `OmdbService.swift`. Replace it with your own key from [omdbapi.com](https://www.omdbapi.com/apikey.aspx) if needed.

---

## Requirements

- Xcode 16 or later
- iOS 18+ deployment target (project is configured for iOS 26.5)

### Build & Run

1. Open `MovieApp-ios.xcodeproj` in Xcode
2. Select a simulator or device
3. Press **⌘R**

No package resolution step is needed — there are no Swift Package Manager dependencies.

---

## Android Counterpart

This app is a direct iOS port of `MovieApp-android` located in the same repository. Both share:

- Identical domain models (`Movie`, `MovieDetails`)
- The same OMDb API endpoints and mapping logic
- The same UX structure: Popular tab → Search tab → Details screen
- The same pagination strategy (page-based, 10 results per page)
- Theme persistence (System / Light / Dark)
