class MahilaMandalSamitiModel {
  final int id;
  final String fullName;
  final String designation;
  final String village;
  final String? mobile;

  MahilaMandalSamitiModel({
    required this.id,
    required this.fullName,
    required this.designation,
    required this.village,
    this.mobile,
  });

  factory MahilaMandalSamitiModel.fromJson(Map<String, dynamic> json) {
    return MahilaMandalSamitiModel(
      id: json['id'],
      fullName: json['full_name'],
      designation: json['designation'],
      village: json['village'],
      mobile: json['mobile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'designation': designation,
      'village': village,
      'mobile': mobile,
    };
  }
}
