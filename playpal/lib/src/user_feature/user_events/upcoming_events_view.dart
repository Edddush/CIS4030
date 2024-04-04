import 'package:flutter/material.dart';
import 'package:playpal/providers/upcoming_events_provider.dart';
import 'package:playpal/src/event_feature/event.dart';
import 'package:playpal/src/event_feature/event_details_view.dart';
import 'package:provider/provider.dart';

class UpcomingEventsView extends StatelessWidget {
  const UpcomingEventsView({super.key});
  static const routeName = '/upcoming_events';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UpcomingEventsProvider>(context);
    final List<Event> events = provider.events;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: const Text('My Upcoming Events'),
      ),
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'My Upcoming Events',
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          final event = events[index];

          return ListTile(
              title: Text(event.name),
              subtitle: Text(event.sport),
              leading: CircleAvatar(
                foregroundImage: NetworkImage(event.thumbnail),
              ),
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
