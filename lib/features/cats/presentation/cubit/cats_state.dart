part of 'cats_cubit.dart';

@immutable
sealed class CatsState {}

class CatsInitial extends CatsState {}

class CatsLoading extends CatsState {}

class CatsListLoaded extends CatsState {
  final List<CatImageModel> cats;

  CatsListLoaded(this.cats);
}

class CatsError extends CatsState {
  final String message;

  CatsError(this.message);
}
