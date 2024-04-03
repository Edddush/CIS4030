import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'event.dart';
import 'dart:async';
import 'dart:convert';
import 'event_details_view.dart';
import 'package:playpal/src/event_feature/hamburger_menu.dart';
import 'package:playpal/src/create_event/create_event.dart';

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

class EventListView extends StatefulWidget {
  const EventListView({super.key});
  static const routeName = '/events';

  @override
  State<EventListView> createState() =>
      _EventListView();
}


/// Displays a list of SampleItems.
class _EventListView extends State<EventListView> {

  static const List<(Color?, Color? background, ShapeBorder?)> customizations =
      <(Color?, Color?, ShapeBorder?)>[
    (null, null, null),
    (null, Colors.green, null),
    (Colors.white, Colors.green, null),
    (Colors.white, Colors.green, CircleBorder()),
  ];
  
  int index = 0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Colors.black54,
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
        onPressed: () {
          setState(() {
            index = (index + 1) % customizations.length;
          });
        },
        foregroundColor: customizations[index].$1,
        backgroundColor: customizations[index].$2,
        shape: customizations[index].$3,
        child: const Icon(Icons.navigation),
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
        return Card(
          // Wrap each ListTile with a Card for better UI
          elevation: 4.0, // Optional: adds a shadow to each card
          margin: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0), // Optional: adds margin around each card
          child: ListTile(
            title: Text(event.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(event.sport),
                Text('Location: ${event.location}'),
                Text('Date: ${event.date}, Time: ${event.time}'),
                Text(
                    'Participants: ${event.currentParticipants}/${event.totalParticipants}'),
              ],
            ),
            leading: CircleAvatar(
              foregroundImage: NetworkImage(event.thumbnail),
            ),
            onTap: () {
              Navigator.restorablePushNamed(context, EventDetailsView.routeName,
                  arguments: event.toMap());
            },
          ),
        );
      },
    );
  }
}
