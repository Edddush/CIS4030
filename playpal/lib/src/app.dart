import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:playpal/providers/all_events.dart';
import 'package:playpal/providers/my_events_provider.dart';
import 'package:playpal/providers/past_events_provider.dart';
import 'package:playpal/src/event_feature/event_details_view.dart';
import 'event_feature/event_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'create_event/create_event.dart';
import 'event_feature/login_page.dart';
import 'package:provider/provider.dart';
import 'user_feature/user_events/past_events_view.dart';
import 'user_feature/user_events/my_events_view.dart';
import 'package:playpal/providers/upcoming_events_provider.dart';
import 'user_feature/user_events/upcoming_events_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<MyEventsProvider>(
              create: (context) => MyEventsProvider()),
          ChangeNotifierProvider<PastEventsProvider>(
              create: (context) => PastEventsProvider()),
          ChangeNotifierProvider<UpcomingEventsProvider>(
              create: (context) => UpcomingEventsProvider()),
          ChangeNotifierProvider<AllEventsProvider>(
              create: (context) => AllEventsProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(
              fontFamily: 'HelveticaNeue', // Use a clear sans-serif font
              textTheme: const TextTheme(
                // Adjust text sizes for optimal readability on iPhones
                // Consider using at least 16-18sp for body text
                titleLarge: TextStyle(fontSize: 20.0),
                bodyLarge: TextStyle(fontSize: 18.0),
                bodyMedium: TextStyle(fontSize: 16.0),
              )),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          home: const LoginPage(),
          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case UserSettings.routeName:
                    return const UserSettings();
                  case MyEventsView.routeName:
                    return MyEventsView();
                  case UpcomingEventsView.routeName:
                    return UpcomingEventsView();
                  case EventDetailsView.routeName:
                    return const EventDetailsView();
                  case CreateEvent.routeName:
                    return const CreateEvent();
                  case PastEventsView.routeName:
                    return PastEventsView();
                  case EventListView.routeName:
                  default:
                    return EventListView();
                }
              },
            );
          },
        ));
  }
}
