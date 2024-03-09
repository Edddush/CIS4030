import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserProfile extends StatefulWidget {
  @override
  const UserProfile({super.key});
  static const routeName = '/user_profile';
  UserProfileState createState() => UserProfileState();

}

class UserProfileState extends State<UserProfile> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Colors.cyan[900],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
                      Navigator.pop(context);
                    },
                    child: Text('My Events', 
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 50),
                      padding: EdgeInsets.symmetric(horizontal: 16.0), 
                      backgroundColor: Colors.cyan[900],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Past Events', 
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 50),
                      padding: EdgeInsets.symmetric(horizontal: 16.0), 
                      backgroundColor: Colors.cyan[900],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Upcoming Events', 
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 50),
                      padding: EdgeInsets.symmetric(horizontal: 16.0), 
                      backgroundColor: Colors.cyan[900],
                      foregroundColor: Colors.white,
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
