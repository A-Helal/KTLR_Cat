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

Entry point initializes DI and launches `SplashScreen` with `AppTheme`.

```12:24:lib/main.dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Adoption',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
```

### API & Configuration
This app uses `https://api.thecatapi.com/`. The API key and endpoints are defined in `core/constants/api_constants.dart`.

Important: For production, do not commit secrets. Move `apiKey` to a secure source (env, remote config, or build-time injection).

```1:13:lib/core/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'https://api.thecatapi.com/';
  static const String apiKey = '...'; // Replace securely for production
  static const String userId = "Helal's cat";
  static const String searchEndpoint = 'v1/images/search';
  static const String favoritesEndpoint = 'v1/favourites';
  static const String breedsEndpoint = 'v1/breeds';
  static const String breedsSearchEndpoint = 'v1/breeds/search';
}
```

### Getting Started
1) Prerequisites
- Flutter SDK installed and configured
- TheCatAPI key (`x-api-key`)

2) Install dependencies
```bash
flutter pub get
```

3) Run
```bash
flutter run -d chrome   # Web
flutter run -d windows  # Windows
flutter run             # Auto-detect device
```

### Project Scripts
- Generate launcher icons (configured in `pubspec.yaml`):
```bash
flutter pub run flutter_launcher_icons:main
```

### State Management Overview
Cubits expose simple flows with `Result` handling and clear states.

```18:39:lib/features/breeds/presentation/cubit/breeds_cubit.dart
emit(BreedsLoading());
final result = await repository.getBreeds(page: _currentPage, limit: _pageSize);
result.when(
  success: (breeds) { /* update and emit BreedsLoaded */ },
  failure: (message) => emit(BreedsError(message)),
);
```

### Networking
`DioClient` configures base URL, headers (including API key), timeouts, and logging.

```4:29:lib/core/network/dio_client.dart
class DioClient {
  late final Dio _dio;
  DioClient() {
    _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl, headers: {
      'x-api-key': ApiConstants.apiKey,
      'Content-Type': 'application/json',
    }));
    _dio.interceptors.add(LogInterceptor(request: true, requestBody: true, responseBody: true, error: true));
  }
  Dio get dio => _dio;
}
```

Centralized error mapping via `ApiException.fromDioError`.

### Dependency Injection
`get_it` registers singletons and factories; favorites cubit preloads data.

```12:28:lib/core/di/injection_container.dart
sl.registerLazySingleton(() => DioClient());
sl.registerLazySingleton(() => CatsRepository(sl()));
sl.registerLazySingleton(() => BreedsRepository(sl()));
sl.registerLazySingleton(() => FavoritesRepository(sl()));
sl.registerFactory(() => CatsCubit(sl()));
sl.registerFactory(() => BreedsCubit(sl()));
sl.registerLazySingleton(() => FavoritesCubit(sl()));
sl<FavoritesCubit>().getFavorites();
```

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

### Contributing
1. Fork and create a feature branch
2. Follow existing code style and architecture
3. Ensure `flutter analyze` passes and add tests where relevant
4. Open a PR with a clear description

### License
This project is for educational/demo purposes. Consider adding a proper license if publishing.
