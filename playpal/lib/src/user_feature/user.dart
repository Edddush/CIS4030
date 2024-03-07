/// A placeholder class that represents an entity or model.
class Event {
  const Event ({
    required this.username,
    required this.password,
    required this.dateOfBirth,
    required this.location,
    required this.picture,
    required this.myEvents,
    required this.pastEvents,
    required this.upcomingEvents
  });

  final String username;
  final String password;
  final String dateOfBirth;
  final String location;
  final String picture;
  final List myEvents;
  final List pastEvents;
  final List upcomingEvents;

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        username: json['username'] as String,
        password: json['password'] as String,
        dateOfBirth: json['date_of_birth'] as String,
        location: json['location'] as String,
        picture: json['picture'] as String,
        myEvents: json['my_events'] as List,
        pastEvents: json['past_events'] as List,
        upcomingEvents: json['upcoming_events'] as List,
    );
  }
}
