import 'package:flutter/material.dart';
import 'package:playpal/src/create_event/create_event.dart';
import 'package:playpal/src/event_feature/event_details_view.dart';
import 'event.dart';
import 'dart:async';
import 'package:playpal/src/event_feature/hamburger_menu.dart';
import 'package:firebase_database/firebase_database.dart';

/// Displays a list of events.
class EventListView extends StatefulWidget {
  EventListView({super.key});

  static const routeName = '/events';
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  @override
  EventListViewState createState() => EventListViewState();
}

class EventListViewState extends State<EventListView> {
  TextEditingController searchController = TextEditingController();
  late List<EventObject> allEvents = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: const Color.fromARGB(255, 8, 98, 54),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Search events...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: onSearchTextChanged,
            ),
          ),
          Expanded(
            child: buildEventList(searchController.text)
          ),
        ],
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

  Widget buildEventList(String searchText) {
    final List<EventObject> filteredEvents = allEvents
        .where((eventObject) => eventObject.event!.sport
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();

    if (filteredEvents.isEmpty) {
      return const Center(child: Text('No events found.'));
    }

    return EventList(eventObjects: filteredEvents);
  }

  void onSearchTextChanged(String searchText) {
    setState(() {});
  }

  Future<void> loadEvents() async {
    try {
      widget.database.child('my_events').onChildAdded.listen((data) {
        Event eventData = Event.fromJson(data.snapshot.value! as Map);
        EventObject eventObject =
            EventObject(key: data.snapshot.key, event: eventData);

        allEvents.add(eventObject);
        setState(() {});
      });
    } catch (error) {
      rethrow;
    }
  }
}

/// Widget to display a list of events.
class EventList extends StatelessWidget {
  const EventList({super.key, required this.eventObjects});

  final List<EventObject> eventObjects;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      restorationId: 'EventListView',
      itemCount: eventObjects.length,
      itemBuilder: (context, index) {
        final event = eventObjects[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: EventListItem(eventObject: event),
        );
      },
    );
  }
}

class EventListItem extends StatelessWidget {
  const EventListItem({super.key, required this.eventObject});

  final EventObject eventObject;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.restorablePushNamed(
          context,
          EventDetailsView.routeName,
          arguments: eventObject.toMap(),
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
                  child: Hero(
                tag: 'sportImage',
                child: Image.network(eventObject.event!.thumbnail),
              )),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventObject.event!.name,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      eventObject.event!.sport,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Location: ${eventObject.event!.location}',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    Text(
                      'Date: ${eventObject.event!.date}, ${eventObject.event!.time}',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    Text(
                      'Participants: ${eventObject.event!.currentParticipants}/${eventObject.event!.totalParticipants}',
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
