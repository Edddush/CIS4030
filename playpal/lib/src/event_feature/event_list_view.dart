import 'package:flutter/material.dart';
import 'package:playpal/src/create_event/create_event.dart';
import 'package:playpal/src/event_feature/event_details_view.dart';
import 'event.dart';
import 'dart:async';
import 'package:playpal/src/event_feature/hamburger_menu.dart';
import 'package:firebase_database/firebase_database.dart';

/// Displays a list of events.
class EventListView extends StatelessWidget {
  EventListView({super.key});

  static const routeName = '/events';
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

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
        future: _loadJournalEntries(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('An error occurred!'));
          } else if (snapshot.hasData) {
            return EventList(events: snapshot.data!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.restorablePushNamed(
            context,
            CreateEvent.routeName,
          );
        },
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 8, 98, 54),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<Event>> _loadJournalEntries() async {
    try {
      final DatabaseEvent event = await _database.child('events').once();
      List<Event> eventList = [];

      if (event.snapshot.value != null) {
        final jsonData = Map<String, dynamic>.from(event.snapshot.value as Map);
        jsonData.forEach((key, value) { eventList.add(Event.fromJson(value));});
      }

      return eventList;
    } catch (error) {
      rethrow;
    }
  }
}

/// Widget to display a list of events.
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
          child: EventListItem(event: event),
        );
      },
    );
  }
}

/// Widget to display an individual event item.
class EventListItem extends StatelessWidget {
  const EventListItem({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.restorablePushNamed(
          context,
          EventDetailsView.routeName,
          arguments: event.toMap(),
        );
      },
      child: Card(
        elevation: 4.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(event.thumbnail),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      event.sport,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Location: ${event.location}',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    Text(
                      'Date: ${event.date}, ${event.time}',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    Text(
                      'Participants: ${event.currentParticipants}/${event.totalParticipants}',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// // ...

// await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
// );