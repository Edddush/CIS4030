class Event {
  Event(
      {required this.name,
      required this.sport,
      required this.location,
      required this.date,
      required this.time,
      required this.totalParticipants,
      required this.currentParticipants,
      required this.thumbnail,
      required this.description,
      required this.isPast});

  final String name;
  final String sport;
  final String location;
  final String date;
  final String time;
  final int totalParticipants;
  int currentParticipants;
  final String thumbnail;
  final List description;
  bool isPast;

  factory Event.fromJson(Map<dynamic, dynamic> json) {
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
        isPast: json['is_past'] as bool);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sport': sport,
      'location': location,
      'date': date,
      'time': time,
      'total_participants': totalParticipants,
      'current_participants': currentParticipants,
      'thumbnail': thumbnail,
      'description': description,
      'is_past': isPast
    };
  }

  Future<void> updateExpirationStatus() async {
    isPast = true;
  }

  void addParticipant(){
    if(totalParticipants > currentParticipants){
      currentParticipants++;
    }
  }

  void removeParticipant(){
    if(currentParticipants > 0){
      currentParticipants--;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Event &&
        other.name == name &&
        other.time == time &&
        other.description == description &&
        other.date == date;
  }

  @override
  int get hashCode => Object.hash(name, time, description, date);
}
