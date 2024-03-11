import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as datatTimePicker;

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});
  static const routeName = '/create_event';

  @override
  CreateEventState createState() => CreateEventState();
}

class CreateEventState extends State<CreateEvent> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  String? selectedSport;
  DateTime? selectedDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  int? maxNumParticipants;
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<String> sports = [
    'Basketball',
    'Soccer',
    'Tennis',
    'Hockey',
    'Squash',
    'Pickle ball',
    "Volleyball"
  ];
  TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
        backgroundColor: Colors.cyan[900],
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
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Sport'),
                  value: selectedSport,
                  onChanged: (value) {
                    setState(() {
                      selectedSport = value as String;
                    });
                  },
                  items: sports.map((String sport) {
                    return DropdownMenuItem<String>(
                      value: sport,
                      child: Text(sport),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a sport';
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
                      labelText: 'Date',
                      hintText: 'Select Date',
                    ),
                    child: Text(
                      selectedDate.toString().substring(0, 10),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showStartTimePicker(context);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Start Time',
                      hintText: 'Select Start Time',
                    ),
                    child: Text(startTime.format(context)),
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
                TextField(
                  controller: numberController,
                  decoration: const InputDecoration(
                    labelText: 'Number of participants',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      maxNumParticipants = int.tryParse(value);
                    });
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  minLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
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
                          List<String> descriptionArray = descriptionController
                              .text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();
                          Map<String, dynamic> eventData = {
                            'name': nameController.text,
                            'sport': selectedSport,
                            'location': locationController.text,
                            'date': selectedDate.toString().substring(0, 10),
                            'time': startTime.format(context),
                            'total_participants': 4,
                            'current_participants': 0,
                            'thumbnail':
                                "https://cdn.pixabay.com/photo/2017/01/31/15/31/tennis-2025095_960_720.png",
                            'description': descriptionArray,
                            'is_past': false
                          };
                          appendToJson(eventData);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 50),
                        padding: EdgeInsets.symmetric(horizontal: 32.0),
                        backgroundColor: Colors.cyan[900],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Create Event',
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
    datatTimePicker.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      onChanged: (dateTime) {},
      onConfirm: (dateTime) {
        setState(() {
          selectedDate = dateTime;
        });
      },
      locale: datatTimePicker.LocaleType.en,
    );
  }

  void showStartTimePicker(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (selectedTime != null) {
      setState(() {
        startTime = selectedTime;
      });
    }
  }
}
