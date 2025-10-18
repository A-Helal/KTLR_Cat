import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/result.dart';
import '../models/cat_image_model.dart';

class CatsRepository {
  final DioClient dioClient;

  CatsRepository(this.dioClient);

  Future<Result<List<CatImageModel>>> getCatsList({int limit = 20}) async {
    try {
      final response = await dioClient.dio.get(
        ApiConstants.searchEndpoint,
        queryParameters: {
          'size': 'med',
          'mime_types': 'jpg',
          'format': 'json',
          'has_breeds': 'true',
          'order': 'RANDOM',
          'limit': limit,
        },
      );

      if (response.statusCode == 200 && response.data is List) {
        final cats = (response.data as List)
            .map((data) => CatImageModel.fromJson(data))
            .toList();
        return Success(cats);
      }
      return const Failure('Failed to load cats');
    } on DioException catch (e) {
      final exception = ApiException.fromDioError(e);
      return Failure(exception.message, exception);
    } catch (e) {
      return Failure('An unexpected error occurred: $e');
    }
  }
}


