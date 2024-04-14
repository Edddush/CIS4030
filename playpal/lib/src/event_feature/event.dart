import 'package:flutter/material.dart';

class EventObject {
  String? key;
  Event? event;

  EventObject({required this.key, required this.event});

  factory EventObject.fromJson(Map<dynamic, dynamic> json) {
    return EventObject(
        key: json['key'] as String,
        event: Event.fromJson(json['event'] as Map));
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key!,
      'event': event!.toMap(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventObject && other.key == key && other.event == event;
  }

  @override
  int get hashCode => Object.hash(key, event);
}

class Event extends ChangeNotifier {
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
      required this.isPast,
      required this.isUpcoming,
      required this.isMine});

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
  bool isUpcoming;
  bool isMine;

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
        isPast: json['is_past'] as bool,
        isUpcoming: json['is_upcoming'] as bool,
        isMine: json['is_mine'] as bool);
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
      'is_past': isPast,
      'is_upcoming': isPast,
      'is_mine': isPast
    };
  }

  Future<void> updateExpirationStatus() async {
    isPast = true;
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
