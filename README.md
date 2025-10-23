## Pet Adoption (Cats) – Flutter App

Modern Flutter application showcasing cats from TheCatAPI with breed discovery, image browsing, and local favorites. Built with a clean, modular architecture, robust networking via Dio, and state management using Bloc (Cubit).

### Features
- Browse random cat images with details
- Discover and paginate through cat breeds
- Search breeds with instant results
- Add/remove favorites (stored via TheCatAPI favourites API)
- Elegant UI with Google Fonts, Lottie loading, and cached images

### Tech Stack
- Flutter 3 (Dart ^3.7)
- State management: flutter_bloc (Cubit)
- Dependency injection: get_it
- HTTP client: dio with interceptors and unified error handling
- Functional result type: `Result<Success|Failure>`
- Image caching: cached_network_image
- Styling: Google Fonts, central `AppTheme`

### Architecture
- Core
  - `core/constants`: API endpoints, colors
  - `core/network`: `DioClient`, `ApiException`
  - `core/di`: service locator init in `injection_container.dart`
  - `core/theme`: central `AppTheme`
  - `core/utils`: `Result` sealed type
- Features (by module)
  - `features/cats`: models, repository, cubit, screens, widgets
  - `features/breeds`: listing, pagination, search
  - `features/favorites`: list, add, remove, favorite state
  - `features/splash`: splash and onboarding screens


### UI/UX Notes
- Material 3 theme with `GoogleFonts.poppins`
- Consistent color system in `AppColors`
- Lottie used for loading animations
- Cached network images to improve performance

### Testing
Run Flutter tests:
```bash
flutter test
```

### Platform Support
- Android, iOS, Web, Windows, macOS

### Roadmap Ideas
- Move API key to secure storage or build-time secrets
- Add offline caching for lists
- Add unit and widget tests for cubits and repositories
- Add CI workflow (format, analyze, test)
4. Open a PR with a clear description

### License
This project is for educational/demo purposes. Consider adding a proper license if publishing.
