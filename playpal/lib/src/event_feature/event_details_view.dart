import 'package:flutter/material.dart';

class EventDetailsView extends StatelessWidget {
  const EventDetailsView({super.key});

  static const routeName = '/event';

  @override
  Widget build(BuildContext context) {
    final Map event = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text(event['name']),
        backgroundColor: Colors.cyan[900],
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FixedImage(thumbnail: event['thumbnail']),
          Expanded(
            child: SingleChildScrollView(
              child: Details(
                  description: event['description'],
                  date: event['date'],
                  time: event['time'],
                  totalParticipants: event['total_participants'],
                  currentParticipants: event['current_participants'],
                  location: event['location']),
            ),
          ),
        ],
      ),
    );
  }
}

class FixedImage extends StatelessWidget {
  const FixedImage({super.key, required this.thumbnail});

  final String thumbnail;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(thumbnail),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class Details extends StatelessWidget {
  const Details({
    super.key,
    required this.description,
    required this.date,
    required this.time,
    required this.totalParticipants,
    required this.currentParticipants,
    required this.location
  });

  final String description;
  final String date;
  final String time;
  final int totalParticipants;
  final int currentParticipants;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Description:",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            description,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            date,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            time,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$currentParticipants/$totalParticipants',
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            location,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
