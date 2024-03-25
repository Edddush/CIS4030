import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as date_time_picker;


class UserSettings extends StatefulWidget {
  static const routeName = '/user_settings';
  const UserSettings({super.key});

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  DateTime? dob;

  void showDatePicker(BuildContext context) {
    date_time_picker.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.parse("1900-01-01"),
      currentTime: dob, 
      onChanged: (dateTime) {},
      onConfirm: (dateTime) {
        setState(() {
          dob = dateTime;
        });
      },
      locale: date_time_picker.LocaleType.en,
    );
  }

 Future<void> appendToJson() async {
  String userJson = await getUserJSON();
  Map<String, dynamic> jsonData = json.decode(userJson);
  jsonData['username'] = usernameController.text;
  if (newPasswordController.text != "") {
    jsonData['password'] = newPasswordController.text;
  }
  jsonData['date_of_birth'] = dob.toString();
  jsonData['location'] = locationController.text;
  String updatedJsonString = JsonEncoder.withIndent('  ').convert(jsonData);
  File file = File('/Users/arthurkowara/Documents/GitHub/CIS4030/playpal/assets/user.json');
  // File file = File('/Users/eddydushime/Documents/Art/Uni/CIS4030/Milestone/M2/CIS4030/playpal/assets/event_list.json');
  await file.writeAsString(updatedJsonString);
}

  Future<String> getUserJSON() async {
    final String response = await rootBundle.loadString('assets/user.json');
    return response;
  }

  @override
void initState() {
  super.initState();
  // Parse the JSON data and fill out the form
  getUserJSON().then((userJson) {
    final jsonData = json.decode(userJson);
    setState(() {
      usernameController.text = jsonData['username'];
      currentPasswordController.text = jsonData['password'];
      dob = DateTime.parse(jsonData['date_of_birth']);
      locationController.text = jsonData['location'];
    });
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Settings'),
        backgroundColor: Colors.black54,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'User Name',
                    prefixIcon: SizedBox(
                      width: 10,
                      height: 10,
                      child: Icon(Icons.alternate_email, size: 20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your user name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: currentPasswordController,
                  decoration: const InputDecoration(labelText: 'Current Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  obscureText: true,
                  enabled: false,
                ),
                TextFormField(
                  controller: newPasswordController,
                  decoration: const InputDecoration(labelText: 'New Password'),
                  obscureText: true,
                ),
                InkWell(
                  onTap: () {
                    showDatePicker(context);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      hintText: 'Select Date',
                    ),
                    child: Text(
                      dob.toString().substring(0, 10),
                    ),
                  ),
                ),
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the location';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState != null &&
                            formKey.currentState!.validate()) {
                            appendToJson();
                              
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 50),
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        backgroundColor: Colors.cyan[900],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
