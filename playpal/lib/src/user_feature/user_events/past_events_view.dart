import 'package:flutter/material.dart';
import 'package:playpal/src/event_feature/event.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:playpal/src/event_feature/event_details_view.dart';

class PastEventsView extends StatefulWidget {
  PastEventsView({super.key});
  static const routeName = '/past_events';
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  @override
  State<PastEventsView> createState() => _PastEventsViewState();
}

class _PastEventsViewState extends State<PastEventsView> {
  late List<EventObject> pastEvents = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 8, 98, 54),
          foregroundColor: Colors.white,
          title: const Text('My Past Events')),
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'My Past Events',
        itemCount: pastEvents.length,
        itemBuilder: (BuildContext context, int index) {
          final eventObject = pastEvents[index];

          return ListTile(
              title: Text(eventObject.event!.name),
              subtitle: Text(eventObject.event!.sport),
              leading: CircleAvatar(
                // Display the Flutter Logo image asset.
                foregroundImage: NetworkImage(eventObject.event!.thumbnail),
              ),
              onTap: () {
                Navigator.restorablePushNamed(
                    context, EventDetailsView.routeName,
                    arguments: eventObject.event!.toMap());
              });
        },
      ),
    );
  }

  Future<void> loadEvents() async {
    try {
      widget.database.child('past_events').onChildAdded.listen((data) {
        Event eventData = Event.fromJson(data.snapshot.value! as Map);
        EventObject eventObject =
            EventObject(key: data.snapshot.key!, event: eventData);
        pastEvents.add(eventObject);
        setState(() {});
      });
    } catch (error) {
      rethrow;
    }
  }
}
