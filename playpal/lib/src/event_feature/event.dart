/// A placeholder class that represents an entity or model.
class Event {
  const Event ({
    required this.name,
    required this.sport,
    required this.location,
    required this.date,
    required this.time,
    required this.totalParticipants,
    required this.currentParticipants,
    required this.thumbnail,
    required this.description
  });

  final String name;
  final String sport;
  final String location;
  final String date;
  final String time;
  final int totalParticipants;
  final int currentParticipants;
  final String thumbnail;
  final List description;

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        name: json['name'] as String,
        sport: json['sport'] as String,
        location: json['location'] as String,
        date: json['date'] as String,
        time: json['time'] as String,
        totalParticipants: json['total_participants'] as int,
        currentParticipants: json['current_participants'] as int,
        thumbnail: json['thumbnail'] as String,
        description: json['description'] as List,
    );
  }
}
