import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'event.dart';
import 'dart:async';
import 'dart:convert';
import 'event_details_view.dart';

Future<List<Event>> fetchEventsFromFile() async {
  // Read the JSON data from the file
  final String response = await rootBundle.loadString('assets/event_list.json');

  return compute(parseEvents, response);
}

// A function that converts a response body into a List<Event>.
List<Event> parseEvents(String responseBody) {
  final parsed = (jsonDecode(responseBody)["events"] as List).cast<Map<String, dynamic>>();

  return parsed.map<Event>((json) => Event.fromJson(json)).toList();
}


/// Displays a list of SampleItems.
class EventListView extends StatelessWidget {
  const EventListView({ super.key });
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Events', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.cyan[900],
        ),
        body: FutureBuilder<List<Event>>(
            future: fetchEventsFromFile(),
            builder: (context, snapshot){
              if(snapshot.hasError){
                return const Center(child: Text('An error occurred!'),);
              } else if (snapshot.hasData) {
                return EventList(events: snapshot.data!);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }
        )
    );
  }
}

class EventList extends StatelessWidget {
  const EventList({super.key, required this.events});

  final List<Event> events;

  @override
  Widget build (BuildContext context){
    return ListView.builder(
      // Providing a restorationId allows the ListView to restore the
      // scroll position when a user leaves and returns to the app after it
      // has been killed while running in the background.
      restorationId: 'EventListView',
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return ListTile(
            title: Text(event.name),
            subtitle: Text(event.sport),
            leading: CircleAvatar(
              // Display the Flutter Logo image asset.
              foregroundImage: NetworkImage(event.thumbnail),
            ),
            onTap: () {
              // Navigate to the details page. If the user leaves and returns to
              // the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(
                context,
                EventDetailsView.routeName,
              );
            }
        );
      },
    );
  }
}
