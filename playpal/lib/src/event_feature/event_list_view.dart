import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'event.dart';
import 'dart:async';
import 'dart:convert';
import 'event_details_view.dart';
import 'package:playpal/src/event_feature/hamburger_menu.dart';

Future<List<Event>> fetchEventsFromFile() async {
  // Read the JSON data from the file
  final String response = await rootBundle.loadString('assets/event_list.json');
  return compute(parseEvents, response);
}

// A function that converts a response body into a List<Event>.
List<Event> parseEvents(String responseBody) {
  final parsed =
      (jsonDecode(responseBody)["events"] as List).cast<Map<String, dynamic>>();
  return parsed.map<Event>((json) => Event.fromJson(json)).toList();
}

/// Displays a list of SampleItems.
class EventListView extends StatelessWidget {
  const EventListView({super.key});
  static const routeName = '/events';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: const Color.fromARGB(255, 8, 98, 54),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Event>>(
          future: fetchEventsFromFile(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('An error occurred!'));
            } else if (snapshot.hasData) {
              return EventList(events: snapshot.data!);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 8, 98, 54),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class EventList extends StatelessWidget {
  const EventList({super.key, required this.events});

  final List<Event> events;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      restorationId: 'EventListView',
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Card(
            elevation: 4.0, // Optional: adds a shadow to each card
            child: ListTile(
              title: Text(
                event.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold, // Making name text bold
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    event.sport,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600, // Making sport text bold
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Location: ${event.location}'),
                  const SizedBox(height: 4),
                  Text('Date: ${event.date}, ${event.time}'),
                  const SizedBox(height: 4),
                  Text(
                    'Participants: ${event.currentParticipants}/${event.totalParticipants}',
                  ),
                ],
              ),
              leading: CircleAvatar(
                foregroundImage: NetworkImage(event.thumbnail),
              ),
              onTap: () {
                Navigator.restorablePushNamed(
                  context,
                  EventDetailsView.routeName,
                  arguments: event.toMap(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}


// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// // ...

// await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
// );