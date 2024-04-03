import 'event.dart';
import 'package:flutter/material.dart';
import 'package:playpal/providers/upcoming_events_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EventDetailsView extends StatelessWidget {
  const EventDetailsView({super.key});

  static const routeName = '/event';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> argument =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Event eventArgument = Event.fromJson(argument);

    return Scaffold(
      appBar: AppBar(
        title: Text(eventArgument.name),
        backgroundColor: Colors.black54,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FixedImage(thumbnail: eventArgument.thumbnail),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
              children: [
                Details(event: eventArgument),
                // Add MapScreen widget here
                // MapScreen(), // This will display the map
              ],
            ),
            ),
          ),
        ],
      ),
    );
  }
}

class FixedImage extends StatelessWidget {
  const FixedImage({super.key, required this.thumbnail});

  final String thumbnail;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(thumbnail),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class Details extends StatelessWidget {
  const Details({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UpcomingEventsProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Description:",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            event.description.join('\n'),
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            event.date,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            event.time,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${event.currentParticipants}/${event.totalParticipants}',
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            event.location,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        // MapScreen(),
        Align(
          alignment: Alignment.bottomCenter,
          child: provider.isUpcomingEvent(event)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 40), // Increase button height
                              textStyle: const TextStyle(fontSize: 26),
                              backgroundColor: Colors.grey,
                              foregroundColor:
                                  Colors.white24 // Increase font size
                              ),
                          child: const Text('Join')),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent[100],
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 40), // Increase button height
                            textStyle: const TextStyle(fontSize: 26),
                          ),
                          onPressed: () {
                            event.removeParticipant();
                            provider.removeFromList(event);
                          },
                          child: const Text('Leave'))
                    ])
              : ElevatedButton(
                  onPressed: () {
                    event.addParticipant();
                    provider.addToList(event);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40), // Increase button height
                    textStyle: const TextStyle(fontSize: 26),
                    backgroundColor: Colors.cyan[900],
                    foregroundColor: Colors.white, // Increase font size
                  ),
                  child: const Text('Join')),
        )
      ],
    );
  }
}
class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
    FlutterMap(
      options: MapOptions(
      center: LatLng(59.438484, 24.742595),
      zoom: 14,
      keepAlive: true
  ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
      ],
    );
  }
}
