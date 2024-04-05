import 'package:flutter/material.dart';
import 'package:playpal/providers/my_events_provider.dart';
import 'package:playpal/src/event_feature/event.dart';
import 'package:playpal/src/event_feature/event_details_view.dart';
import 'package:provider/provider.dart';

class MyEventsView extends StatelessWidget {
  const MyEventsView({super.key});
  static const routeName = '/my_events';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyEventsProvider>(context);
    final List<Event> events = provider.events;
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
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          final event = events[index];

          return ListTile(
              title: Text(event.name),
              subtitle: Text(event.sport),
              leading: CircleAvatar(
                  child: Hero(
                tag: 'sportImage',
                child: Image.network(event.thumbnail),
              )),
              onTap: () {
                Navigator.restorablePushNamed(
                    context, EventDetailsView.routeName,
                    arguments: event.toMap());
              });
        },
      ),
    );
  }
}
