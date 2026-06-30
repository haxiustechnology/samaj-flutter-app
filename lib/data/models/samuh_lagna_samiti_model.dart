class SamuhLagnaSamitiModel {
  final int id;
  final String fullName;
  final String designation;
  final String village;
  final String? mobile;

  SamuhLagnaSamitiModel({
    required this.id,
    required this.fullName,
    required this.designation,
    required this.village,
    this.mobile,
  });

  factory SamuhLagnaSamitiModel.fromJson(Map<String, dynamic> json) {
    return SamuhLagnaSamitiModel(
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
