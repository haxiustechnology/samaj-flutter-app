class BannerModel {
  final int id;
  final String image;
  final String status;

  BannerModel({
    required this.id,
    required this.image,
    required this.status,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      image: json['image'] ?? '',
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'status': status,
    };
  }
}
