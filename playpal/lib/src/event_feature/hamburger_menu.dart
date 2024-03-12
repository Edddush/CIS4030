import 'package:flutter/material.dart';
import 'package:playpal/src/event_feature/login_page.dart';
import 'package:playpal/src/user_feature/user_profile.dart';
import 'package:playpal/src/event_feature/event_list_view.dart';
import 'package:playpal/src/settings/settings_view.dart';

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