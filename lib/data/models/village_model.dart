class Village {
  final int id;
  final String villageName;

  Village({required this.id, required this.villageName});

  factory Village.fromJson(Map<String, dynamic> json) {
    return Village(
      id: json['id'],
      villageName: json['village_name'] ?? '',
    );
  }
}
