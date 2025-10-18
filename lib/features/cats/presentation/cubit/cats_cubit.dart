import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/utils/result.dart';
import '../../data/models/cat_image_model.dart';
import '../../data/repos/cats_repository.dart';

part 'cats_state.dart';

class CatsCubit extends Cubit<CatsState> {
  final CatsRepository repository;

  CatsCubit(this.repository) : super(CatsInitial());

  Future<void> getCatsList({int limit = 10}) async {
    emit(CatsLoading());
    
    final result = await repository.getCatsList(limit: limit);
    
    result.when(
      success: (cats) {
        if (cats.isNotEmpty) {
          emit(CatsListLoaded(cats));
        } else {
          emit(CatsError('No cats available at the moment'));
        }
      },
      failure: (message) => emit(CatsError(message)),
    );
  }
}


