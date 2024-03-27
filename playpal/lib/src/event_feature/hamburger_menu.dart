import 'package:flutter/material.dart';
import 'package:playpal/src/event_feature/login_page.dart';
import 'package:playpal/src/user_feature/user_profile.dart';
import 'package:playpal/src/event_feature/event_list_view.dart';
import 'package:playpal/src/settings/settings_view.dart';
import 'package:playpal/src/user_feature/user_events/past_events_view.dart';
import 'package:playpal/src/user_feature/user_events/my_events_view.dart';
import 'package:playpal/src/user_feature/user_events/upcoming_events_view.dart';

class NavBar extends StatelessWidget{
  const NavBar({super.key});

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
              child:
                Center(
                    child: Text('PlayPal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 54))
                )
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Events'),
            onTap: () => {
              Navigator.restorablePushNamed(
                  context,
                  EventListView.routeName)
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.sports_soccer),
            title: const Text('My Events'),
            onTap: () => {
              Navigator.restorablePushNamed(
                  context,
                  MyEventsView.routeName,
              )
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.done_all),
            title: const Text('Past Events'),
            onTap: () => {
              Navigator.restorablePushNamed(
                context, 
                PastEventsView.routeName)
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.upcoming),
            title: const Text('Upcoming Events'),
            onTap: () => {
              Navigator.restorablePushNamed(
                context, UpcomingEventsView.routeName)
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('User Profile'),
            onTap: () => {
              Navigator.restorablePushNamed(
              context,
              UserProfile.routeName)
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => {
              Navigator.restorablePushNamed(
                  context,
                  UserSettings.routeName)
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () => {
              Navigator.pushReplacementNamed(
                  context,
                  LoginPage.routeName)
            },
          ),
        ],
      ),
    );
  }
}