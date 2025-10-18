import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/utils/result.dart';
import '../../data/models/favorite_model.dart';
import '../../data/repos/favorites_repository.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository repository;
  List<FavoriteModel> _favorites = [];

  FavoritesCubit(this.repository) : super(FavoritesInitial());

  Future<void> getFavorites() async {
    emit(FavoritesLoading());
    
    final result = await repository.getFavorites();
    
    result.when(
      success: (favorites) {
        _favorites = favorites;
        emit(FavoritesLoaded(favorites));
      },
      failure: (message) => emit(FavoritesError(message)),
    );
  }

  Future<bool> addToFavorites(String imageId) async {
    final result = await repository.addToFavorites(imageId);
    
    return result.when(
      success: (_) {
        getFavorites(); // Refresh the list
        return true;
      },
      failure: (_) => false,
    );
  }

  Future<bool> removeFromFavorites(int favoriteId) async {
    final result = await repository.removeFromFavorites(favoriteId);
    
    return result.when(
      success: (_) {
        getFavorites(); // Refresh the list
        return true;
      },
      failure: (_) => false,
    );
  }

  bool isFavorite(String imageId) {
    return _favorites.any((fav) => fav.imageId == imageId);
  }

  int? getFavoriteId(String imageId) {
    try {
      return _favorites.firstWhere((fav) => fav.imageId == imageId).id;
    } catch (e) {
      return null;
    }
  }
}
