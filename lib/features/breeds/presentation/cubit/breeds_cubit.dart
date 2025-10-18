import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/utils/result.dart';
import '../../data/models/breed_model.dart';
import '../../data/repos/breeds_repository.dart';

part 'breeds_state.dart';

class BreedsCubit extends Cubit<BreedsState> {
  final BreedsRepository repository;
  
  int _currentPage = 0;
  List<BreedModel> _allBreeds = [];
  static const int _pageSize = 10;

  BreedsCubit(this.repository) : super(BreedsInitial());

  Future<void> getBreeds({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _allBreeds = [];
    }
    
    emit(BreedsLoading());
    
    final result = await repository.getBreeds(
      page: _currentPage,
      limit: _pageSize,
    );

    result.when(
      success: (breeds) {
        _allBreeds.addAll(breeds);
        _currentPage++;
        emit(BreedsLoaded(_allBreeds, hasMore: breeds.length == _pageSize));
      },
      failure: (message) => emit(BreedsError(message)),
    );
  }

  Future<void> loadMore() async {
    if (state is! BreedsLoaded) return;
    
    final currentState = state as BreedsLoaded;
    if (!currentState.hasMore) return;

    final result = await repository.getBreeds(
      page: _currentPage,
      limit: _pageSize,
    );

    result.when(
      success: (breeds) {
        _allBreeds.addAll(breeds);
        _currentPage++;
        emit(BreedsLoaded(_allBreeds, hasMore: breeds.length == _pageSize));
      },
      failure: (_) {}, // Silently fail on pagination
    );
  }

  Future<void> searchBreeds(String query) async {
    if (query.trim().isEmpty) {
      await getBreeds(refresh: true);
      return;
    }

    emit(BreedsLoading());
    
    final result = await repository.searchBreeds(query.trim());
    
    result.when(
      success: (breeds) => emit(BreedsLoaded(breeds, hasMore: false)),
      failure: (message) => emit(BreedsError(message)),
    );
  }
}

