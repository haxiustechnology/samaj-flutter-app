class NewsModel {
  final int id;
  final String title;
  final String description;
  final String? image;
  final String? createdAt;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    this.createdAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'created_at': createdAt,
    };
  }
}
