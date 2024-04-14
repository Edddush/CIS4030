import 'package:flutter/material.dart';
import 'package:playpal/src/event_feature/event.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:playpal/src/event_feature/event_details_view.dart';

class UpcomingEventsView extends StatefulWidget {
  UpcomingEventsView({super.key});
  static const routeName = '/upcoming_events';
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  @override
  State<UpcomingEventsView> createState() => _UpcomingEventsViewState();
}

class _UpcomingEventsViewState extends State<UpcomingEventsView> {
  late List<EventObject> upcomingEvents = [];

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
        title: const Text('My Upcoming Events'),
      ),
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'My Upcoming Events',
        itemCount: upcomingEvents.length,
        itemBuilder: (BuildContext context, int index) {
          final eventObject = upcomingEvents[index];

          return ListTile(
              title: Text(eventObject.event!.name),
              subtitle: Text(eventObject.event!.sport),
              leading: CircleAvatar(
                foregroundImage: NetworkImage(eventObject.event!.thumbnail),
              ),
              onTap: () {
                Navigator.restorablePushNamed(
                    context, EventDetailsView.routeName,
                    arguments: eventObject.toMap());
              });
        },
      ),
    );
  }

  Future<void> loadEvents() async {
    try {
      widget.database.child('upcoming_events').onChildAdded.listen((data) {
        Event eventData = Event.fromJson(data.snapshot.value! as Map);
        EventObject eventObject =
            EventObject(key: data.snapshot.key!, event: eventData);
        upcomingEvents.add(eventObject);
        setState(() {});
      });
    } catch (error) {
      rethrow;
    }
  }
}
