class AdvertiseModel {
  final int id;
  final String title;
  final String description;
  final String? image;
  final String? companyName;
  final String? contactMobile;
  final String? createdAt;

  AdvertiseModel({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    this.companyName,
    this.contactMobile,
    this.createdAt,
  });

  factory AdvertiseModel.fromJson(Map<String, dynamic> json) {
    return AdvertiseModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      companyName: json['company_name'],
      contactMobile: json['contact_mobile'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'company_name': companyName,
      'contact_mobile': contactMobile,
      'created_at': createdAt,
    };
  }
}
