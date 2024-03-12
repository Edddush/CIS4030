import 'package:flutter/material.dart';
import 'package:playpal/providers/past_events_provider.dart';
import 'package:playpal/src/event_feature/event.dart';
import 'package:playpal/src/user_feature/user_events/my_events_view.dart';
import 'package:playpal/src/user_feature/user_events/past_events_view.dart';
import 'package:playpal/src/user_feature/user_events/upcoming_events_view.dart';
import '../../providers/upcoming_events_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class UserProfile extends StatefulWidget {
  @override
  const UserProfile({super.key});
  static const routeName = '/user_profile';
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  final formKey = GlobalKey<FormState>();

  Future<bool> checkEventTime(Event event) async {
    final format = DateFormat.jm();
    DateTime eventDate = DateTime.parse(event.date);
    TimeOfDay eventTime = TimeOfDay.fromDateTime(format.parse(event.time));
    DateTime eventDateAndTime = DateTime(eventDate.year, eventDate.month,
        eventDate.day, eventTime.hour, eventTime.minute);

    return eventDateAndTime.isBefore(DateTime.now());
  }

  Future<void> checkEventExpiration(BuildContext context) async {
    final upcomingProvider =
        Provider.of<UpcomingEventsProvider>(context, listen: false);
    final pastProvider =
        Provider.of<PastEventsProvider>(context, listen: false);

    List<Event> events = upcomingProvider.events;

    for (var event in events) {
      if (await checkEventTime(event)) {
        await event.updateExpirationStatus();
        await pastProvider.addToList(event);
        await upcomingProvider.removeFromList(event);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.black54,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.restorablePushNamed(
                        context,
                        MyEventsView.routeName,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      backgroundColor: Colors.cyan[900],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'My Events',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.restorablePushNamed(
                          context, PastEventsView.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      backgroundColor: Colors.cyan[900],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Past Events',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.restorablePushNamed(
                          context, UpcomingEventsView.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      backgroundColor: Colors.cyan[900],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Upcoming Events',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
