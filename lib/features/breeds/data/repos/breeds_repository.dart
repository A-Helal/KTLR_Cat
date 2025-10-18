import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/result.dart';
import '../models/breed_model.dart';

class BreedsRepository {
  final DioClient dioClient;

  BreedsRepository(this.dioClient);

  Future<Result<List<BreedModel>>> getBreeds({
    int page = 0,
    int limit = 10,
  }) async {
    try {
      final response = await dioClient.dio.get(
        ApiConstants.breedsEndpoint,
        queryParameters: {
          'limit': limit,
          'page': page,
        },
      );

      if (response.statusCode == 200 && response.data is List) {
        final breeds = (response.data as List)
            .map((breed) => BreedModel.fromJson(breed))
            .toList();
        return Success(breeds);
      }
      return const Failure('Failed to load breeds');
    } on DioException catch (e) {
      final exception = ApiException.fromDioError(e);
      return Failure(exception.message, exception);
    } catch (e) {
      return Failure('An unexpected error occurred: $e');
    }
  }

  Future<Result<List<BreedModel>>> searchBreeds(String query) async {
    try {
      final response = await dioClient.dio.get(
        ApiConstants.breedsSearchEndpoint,
        queryParameters: {
          'q': query,
          'attach_image': '1',
        },
      );

      if (response.statusCode == 200 && response.data is List) {
        final breeds = (response.data as List)
            .map((breed) => BreedModel.fromJson(breed))
            .toList();
        return Success(breeds);
      }
      return const Failure('No breeds found');
    } on DioException catch (e) {
      final exception = ApiException.fromDioError(e);
      return Failure(exception.message, exception);
    } catch (e) {
      return Failure('An unexpected error occurred: $e');
    }
  }
}


