class FavoriteModel {
  final int? id;
  final String? imageId;
  final FavoriteImageModel? image;

  FavoriteModel({
    this.id,
    this.imageId,
    this.image,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      imageId: json['image_id'],
      image: json['image'] != null
          ? FavoriteImageModel.fromJson(json['image'])
          : null,
    );
  }
}

class FavoriteImageModel {
  final String url;

  FavoriteImageModel({
    required this.url,
  });

  factory FavoriteImageModel.fromJson(Map<String, dynamic> json) {
    return FavoriteImageModel(
      url: json['url'] ?? '',
    );
  }
}


