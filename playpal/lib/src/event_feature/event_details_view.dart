import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'event.dart';
import 'package:playpal/providers/upcoming_events_provider.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

class EventDetailsView extends StatefulWidget {
  const EventDetailsView({super.key});
  static const routeName = '/event_details';

  @override
  State<EventDetailsView> createState() => _EventDetailsViewState();
}

class _EventDetailsViewState extends State<EventDetailsView> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int addParticipant(Event event) {
    if (event.totalParticipants > event.currentParticipants) {
      event.currentParticipants++;
    }
    return event.currentParticipants;
  }

  int removeParticipant(Event event) {
    if (event.currentParticipants > 0) {
      event.currentParticipants--;
    }
    return event.currentParticipants;
  }

  @override
  Widget build(BuildContext context) {
    final EventObject argument =
        ModalRoute.of(context)!.settings.arguments as EventObject;

    final Event event = Event.fromJson(argument.event!.toMap());

    final provider = Provider.of<UpcomingEventsProvider>(context);
    Future<void> appendToJson(EventObject? eventObject) async {
      try {
        await _database
            .child('upcoming_events')
            .push()
            .set(eventObject!.event!.toMap())
            .then((value) {
          provider.addToList(eventObject);
          setState(() {});
        });
      } catch (error) {
        rethrow;
      }
    }

    Future<void> removeFromJson(EventObject? eventObject) async {
      try {
        await _database
            .child('upcoming_events')
            .child(eventObject!.key!)
            .remove()
            .then((value) {
          provider.removeFromList(eventObject);
          setState(() {});
        });
      } catch (error) {
        rethrow;
      }
    }

    void joinParticipationUpdate({EventObject? eventObject}) {
      String key = eventObject!.key!;
      Event event = eventObject.event!;
      int value = addParticipant(event);

      _database
          .child("events")
          .child(key)
          .update({"current_participants": value}).then((value) {
        appendToJson(eventObject);
      });
    }

    void leaveParticipationUpdate({EventObject? eventObject}) {
      String key = eventObject!.key!;
      Event event = eventObject.event!;
      int value = removeParticipant(event);

      _database
          .child("events")
          .child(key)
          .update({"current_participants": value}).then((value) {
        removeFromJson(eventObject);
      });
    }

    final String participantCount =
        '${event.currentParticipants}/${event.totalParticipants}';

    GoogleMapController mapController;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        backgroundColor: const Color.fromARGB(255, 8, 98, 54),
        foregroundColor: Colors.white
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            Hero(tag: 'sportImage', child: Image.network(event.thumbnail)),
            const SizedBox(height: 16),
            // Event Name
            Text(
              event.name,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            // Event Details
            _buildEventDetailRow(context, 'Sport', event.sport),
            _buildEventDetailRow(context, 'Location', event.location),
            _buildEventDetailRow(context, 'Date', event.date),
            _buildEventDetailRow(context, 'Time', event.time),
            _buildEventDetailRow(context, 'Participants', participantCount),
            const Divider(),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            ...event.description.map((desc) => Text(desc)),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: provider.isUpcomingEvent(argument)
                  ? ElevatedButton(
                      onPressed: () {
                        leaveParticipationUpdate(eventObject: argument);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Text(
                        'Leave Event',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        joinParticipationUpdate(eventObject: argument);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Text(
                        'Join Event',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            // Google Map

            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: GoogleMap(
                key: const Key('AIzaSyBwbN0fky_wzAi59JEqcGX4uYldNNzCgNk'),
                initialCameraPosition: const CameraPosition(
                  target: LatLng(43.5507158, -80.2510604),
                  zoom: 15,
                ),
                markers: {
                  const Marker(
                    markerId: MarkerId("event_location"),
                    position: LatLng(43.5507158, -80.2510604),
                  )
                },
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                mapType: MapType.normal,
                onTap: (coord) => print('tapped $coord'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build event detail row
  Widget _buildEventDetailRow(
      BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
