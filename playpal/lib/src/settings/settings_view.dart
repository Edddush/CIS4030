import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:playpal/src/settings/settings_controller.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as date_time_picker;

class UserSettings extends StatefulWidget {
  const UserSettings({super.key, required this.controller});
  final SettingsController controller;
  static const routeName = '/user_settings';

  @override
  UserSettingsState createState() => UserSettingsState();
}

class UserSettingsState extends State<UserSettings> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  String? selectedSport;
  DateTime? selectedDate = DateTime.now();
  TextEditingController locationController = TextEditingController();

  Future<void> appendToJson(Map<String, dynamic> newEvent) async {
    File file = File(
        '/Users/arthurkowara/Documents/GitHub/CIS4030/playpal/assets/event_list.json');
    String jsonString = await file.readAsString();
    Map<String, dynamic> jsonData = json.decode(jsonString);
    List<dynamic> existingEvents = jsonData['events'];
    existingEvents.add(newEvent);
    await file
        .writeAsString(const JsonEncoder.withIndent('  ').convert(jsonData));
  }

  void showDatePicker(BuildContext context) {
    date_time_picker.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      onChanged: (dateTime) {},
      onConfirm: (dateTime) {
        setState(() {
          selectedDate = dateTime;
        });
      },
      locale: date_time_picker.LocaleType.en,
    );
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
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: nameController,
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
                  controller: nameController,
                  decoration:
                      const InputDecoration(labelText: 'Current Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'New Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password';
                    }
                    return null;
                  },
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
                      selectedDate.toString().substring(0, 10),
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
