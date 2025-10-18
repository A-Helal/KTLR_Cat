import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/result.dart';
import '../models/favorite_model.dart';

class FavoritesRepository {
  final DioClient dioClient;

  FavoritesRepository(this.dioClient);

  Future<Result<List<FavoriteModel>>> getFavorites() async {
    try {
      final response = await dioClient.dio.get(
        ApiConstants.favoritesEndpoint,
        queryParameters: {'sub_id': ApiConstants.userId},
      );

      if (response.statusCode == 200 && response.data is List) {
        final favorites = (response.data as List)
            .map((favorite) => FavoriteModel.fromJson(favorite))
            .toList();
        return Success(favorites);
      }
      return const Failure('Failed to load favorites');
    } on DioException catch (e) {
      final exception = ApiException.fromDioError(e);
      return Failure(exception.message, exception);
    } catch (e) {
      return Failure('An unexpected error occurred: $e');
    }
  }

  Future<Result<void>> addToFavorites(String imageId) async {
    try {
      final response = await dioClient.dio.post(
        ApiConstants.favoritesEndpoint,
        data: {
          'image_id': imageId,
          'sub_id': ApiConstants.userId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Success(null);
      }
      return const Failure('Failed to add to favorites');
    } on DioException catch (e) {
      final exception = ApiException.fromDioError(e);
      return Failure(exception.message, exception);
    } catch (e) {
      return Failure('An unexpected error occurred: $e');
    }
  }

  Future<Result<void>> removeFromFavorites(int favoriteId) async {
    try {
      final response = await dioClient.dio.delete(
        '${ApiConstants.favoritesEndpoint}/$favoriteId',
      );

      if (response.statusCode == 200) {
        return const Success(null);
      }
      return const Failure('Failed to remove from favorites');
    } on DioException catch (e) {
      final exception = ApiException.fromDioError(e);
      return Failure(exception.message, exception);
    } catch (e) {
      return Failure('An unexpected error occurred: $e');
    }
  }
}


