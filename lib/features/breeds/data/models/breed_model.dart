class BreedModel {
  final String id;
  final String name;
  final String? description;
  final String? temperament;
  final String? origin;
  final String? lifeSpan;
  final int? adaptability;
  final int? affectionLevel;
  final int? childFriendly;
  final String? referenceImageId;

  BreedModel({
    required this.id,
    required this.name,
    this.description,
    this.temperament,
    this.origin,
    this.lifeSpan,
    this.adaptability,
    this.affectionLevel,
    this.childFriendly,
    this.referenceImageId,
  });

  factory BreedModel.fromJson(Map<String, dynamic> json) {
    return BreedModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      temperament: json['temperament'],
      origin: json['origin'],
      lifeSpan: json['life_span'],
      adaptability: json['adaptability'],
      affectionLevel: json['affection_level'],
      childFriendly: json['child_friendly'],
      referenceImageId: json['reference_image_id'],
    );
  }
}


