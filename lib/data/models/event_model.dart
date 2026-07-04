class EventModel {
  final int id;
  final String title;
  final String description;
  final String eventDate;
  final String? image;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    this.image,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      eventDate: json['event_date'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'event_date': eventDate,
      'image': image,
    };
  }
}
