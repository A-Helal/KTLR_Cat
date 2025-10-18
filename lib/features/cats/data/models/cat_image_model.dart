import '../../../breeds/data/models/breed_model.dart';

class CatImageModel {
  final String id;
  final String url;
  final int? width;
  final int? height;
  final List<BreedModel>? breeds;

  CatImageModel({
    required this.id,
    required this.url,
    this.width,
    this.height,
    this.breeds,
  });

  factory CatImageModel.fromJson(Map<String, dynamic> json) {
    return CatImageModel(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      width: json['width'],
      height: json['height'],
      breeds: json['breeds'] != null && (json['breeds'] as List).isNotEmpty
          ? (json['breeds'] as List)
              .map((breed) => BreedModel.fromJson(breed))
              .toList()
          : null,
    );
  }
}


