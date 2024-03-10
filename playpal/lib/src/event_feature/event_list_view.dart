import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'event.dart';
import 'dart:async';
import 'dart:convert';
import 'event_details_view.dart';
import '../create_event/create_event.dart';
import '../user_feature/user_profile.dart';

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

 Widget build(BuildContext context) {
    return ListView.builder(
      restorationId: 'EventListView',
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card( // Wrap each ListTile with a Card for better UI
          elevation: 4.0, // Optional: adds a shadow to each card
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Optional: adds margin around each card
          child: ListTile(
            title: Text(event.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(event.sport),
                Text('Location: ${event.location}'),
                Text('Date: ${event.date}, Time: ${event.time}'),
                Text('Participants: ${event.currentParticipants}/${event.totalParticipants}'),
              ],
            ),
            leading: CircleAvatar(
              foregroundImage: NetworkImage(event.thumbnail),
            ),
            onTap: () {
              Navigator.restorablePushNamed(
                context,
                EventDetailsView.routeName,
                arguments: {
                  'name': event.name,
                  'date': event.date,
                  'time': event.time,
                  'total_participants': event.totalParticipants,
                  'current_participants': event.currentParticipants,
                  'thumbnail': event.thumbnail,
                  'description': event.description.join('\n'),
                  'location': event.location
                }
              );
            },
          ),
        );
      },
    );
  }
}
