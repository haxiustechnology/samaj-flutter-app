class GalleryModel {
  final int id;
  final String image;
  final String mediaType;

  GalleryModel({
    required this.id,
    required this.image,
    required this.mediaType,
  });

  factory GalleryModel.fromJson(Map<String, dynamic> json) {
    return GalleryModel(
      id: json['id'],
      image: json['image'] ?? '',
      mediaType: json['media_type'] ?? 'image',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'media_type': mediaType,
    };
  }
}
