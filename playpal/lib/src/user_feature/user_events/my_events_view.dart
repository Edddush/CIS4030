import 'package:flutter/material.dart';
import 'package:playpal/src/event_feature/event.dart';
import 'package:playpal/src/event_feature/event_details_view.dart';
import 'package:firebase_database/firebase_database.dart';

class MyEventsView extends StatefulWidget {
  MyEventsView({super.key});
  static const routeName = '/my_events';
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  @override
  State<MyEventsView> createState() => _MyEventsViewState();
}

class _MyEventsViewState extends State<MyEventsView> {
  late List<EventObject> myEvents = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<MyEventsProvider>(context);
    // final List<EventObject> eventObjects = provider.eventObjects;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 8, 98, 54),
          foregroundColor: Colors.white,
          title: const Text('My Events')),
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'My Events',
        itemCount: myEvents.length,
        itemBuilder: (BuildContext context, int index) {
          final eventObject = myEvents[index];

          return ListTile(
              title: Text(eventObject.event!.name),
              subtitle: Text(eventObject.event!.sport),
              leading: CircleAvatar(
                  child: Hero(
                tag: 'sportImage',
                child: Image.network(eventObject.event!.thumbnail),
              )),
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
      widget.database.child('my_events').onChildAdded.listen((data) {
        Event eventData = Event.fromJson(data.snapshot.value! as Map);
        EventObject eventObject =
            EventObject(key: data.snapshot.key!, event: eventData);
        myEvents.add(eventObject);
        setState(() {});
      });
    } catch (error) {
      rethrow;
    }
  }
}
