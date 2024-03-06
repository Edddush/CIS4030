/// A placeholder class that represents an entity or model.
class Event {
  const Event ({
    required this.name,
    required this.sport,
    required this.location,
    required this.date,
    required this.time,
    required this.thumbnail,
    required this.description,
  });

  final String name;
  final String sport;
  final String location;
  final String date;
  final String time;
  final String thumbnail;
  final List description;

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        name: json['name'] as String,
        sport: json['sport'] as String,
        location: json['location'] as String,
        date: json['date'] as String,
        time: json['time'] as String,
        thumbnail: json['imageUrl'] as String,
        description: json['description'] as List,
    );
  }
}
