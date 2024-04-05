import 'package:flutter/material.dart';
import 'package:playpal/providers/past_events_provider.dart';
import 'package:playpal/src/event_feature/event.dart';
import 'package:playpal/src/event_feature/event_details_view.dart';
import 'package:provider/provider.dart';

class PastEventsView extends StatelessWidget {
  const PastEventsView({super.key});
  static const routeName = '/past_events';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PastEventsProvider>(context);
    final List<EventObject> eventObjects = provider.events;
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
        itemCount: eventObjects.length,
        itemBuilder: (BuildContext context, int index) {
          final eventObject = eventObjects[index];

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
}
