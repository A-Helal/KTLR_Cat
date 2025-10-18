import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../../features/cats/data/repos/cats_repository.dart';
import '../../features/cats/presentation/cubit/cats_cubit.dart';
import '../../features/breeds/data/repos/breeds_repository.dart';
import '../../features/breeds/presentation/cubit/breeds_cubit.dart';
import '../../features/favorites/data/repos/favorites_repository.dart';
import '../../features/favorites/presentation/cubit/favorites_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient());

  // Repositories
  sl.registerLazySingleton(() => CatsRepository(sl()));
  sl.registerLazySingleton(() => BreedsRepository(sl()));
  sl.registerLazySingleton(() => FavoritesRepository(sl()));

  // Cubits Register as factories cause each screen gets a new instance
  sl.registerFactory(() => CatsCubit(sl()));
  sl.registerFactory(() => BreedsCubit(sl()));
  sl.registerLazySingleton(() => FavoritesCubit(sl()));
  
  // Initialize favorites cubit
  sl<FavoritesCubit>().getFavorites();
}



