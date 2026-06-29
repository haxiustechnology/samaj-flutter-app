class UserModel {
  final int id;
  final String name;
  final String mobile;
  final String? email;
  final String? dateOfBirth;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.mobile,
    this.email,
    this.dateOfBirth,
    this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json['id']?.toString() ?? json['_id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'],
      profileImage: json['profile_image'],
      dateOfBirth: json['dateOfBirth'] ?? json['date_of_birth'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      if (email != null) 'email': email,
      if (profileImage != null) 'profile_image': profileImage,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
    };
  }
}
