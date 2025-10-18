part of 'breeds_cubit.dart';

@immutable
sealed class BreedsState {}

class BreedsInitial extends BreedsState {}

class BreedsLoading extends BreedsState {}

class BreedsLoaded extends BreedsState {
  final List<BreedModel> breeds;
  final bool hasMore;

  BreedsLoaded(this.breeds, {this.hasMore = true});
}

class BreedsError extends BreedsState {
  final String message;

  BreedsError(this.message);
}
