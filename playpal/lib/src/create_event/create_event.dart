import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import '../event_feature/event_list_view.dart';
import 'package:provider/provider.dart';
import '../event_feature/event.dart';
import 'package:playpal/providers/my_events_provider.dart';
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
  String selectedSport = "Basketball";
  String selectedLocation = "Event Center";
  DateTime? selectedDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  int maxNumParticipants = 0;
  String cost = "";
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dressCodeController = TextEditingController();
  TextEditingController costController = TextEditingController();
  List<String> sports = ['Basketball', 'Hockey', 'Pickleball', 'Soccer', 'Squash', 'Tennis', "Volleyball"];
  List<String> locations = ['Event Center', 'Fieldhouse', 'Mitchell Gym', 'Small Gym', 'Squash Courts', 'Tennis Courts', "West Gym"];
  TextEditingController numberController = TextEditingController();
  TextEditingController disclaimerController = TextEditingController();
  TextEditingController equipmentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyEventsProvider>(context);
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
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Location'),
                  value: selectedLocation,
                  onChanged: (value) {
                    setState(() {
                      selectedLocation = value as String;
                    });
                  },
                  items: locations.map((String location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a Location';
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
                      maxNumParticipants = int.parse(value);
                    });
                  },
                ),
                TextField(
                  controller: costController,
                  decoration: const InputDecoration(
                    labelText: 'Cost',
                    prefixIcon: Icon(Icons.attach_money)
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      if (value == "0"){
                        cost = "Free";
                      }
                      else{
                        cost = "\$" + value;
                      }
                        

                    });
                  },
                ),
                TextFormField(
                  controller: dressCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Dress Code',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the dress code';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: equipmentController,
                  decoration: const InputDecoration(
                    labelText: 'Equipment Needed',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter equipment needed';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: disclaimerController,
                  decoration: const InputDecoration(
                    labelText: 'Additional Information',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter additional information';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState != null && formKey.currentState!.validate()) {
                          List<String> descriptionArray = [cost, equipmentController.text, disclaimerController.text, dressCodeController.text];
                          Event event;
                          String thumbnail = "";
                          if (selectedSport == "Basketball"){
                            thumbnail = "https://cdn.pixabay.com/photo/2013/07/12/14/07/basketball-147794_960_720.png";
                          }else if (selectedSport == "Soccer"){
                            thumbnail = "https://cdn.pixabay.com/photo/2013/07/13/10/51/football-157930_960_720.png";
                          }else if (selectedSport == "Tennis"){
                            thumbnail = "https://cdn.pixabay.com/photo/2017/01/31/15/31/tennis-2025095_960_720.png";
                          }else if (selectedSport == "Hockey"){
                            thumbnail = "https://media.istockphoto.com/id/1464504444/photo/ice-hockey-players-on-the-grand-ice-arena-stadium.jpg?s=612x612&w=0&k=20&c=EQThnou2nV5mScmdWyMXbxo2B03zD3ACy9rnfMs_JPI=";
                          }else if (selectedSport == "Squash"){
                            thumbnail = "https://media.istockphoto.com/id/1400118233/photo/closeup-of-unknown-athletic-squash-player-using-a-racket-to-hit-a-ball-during-a-court-game.webp?s=1024x1024&w=is&k=20&c=pGYz9x6TXj2EZYNFDvBTjEjCZKXgv2-HlexIFnLEHZ4=";
                          }else if (selectedSport == "Volleyball"){
                            thumbnail = "https://media.istockphoto.com/id/618341990/photo/volleyball-ball-isolated-on-white-background.jpg?b=1&s=612x612&w=0&k=20&c=F8CwbWG-uGZbWc4ry0nA3iZZAXBKX7hVsjU5fI53QTQ=";
                          }else if (selectedSport == "PickelBall"){
                            thumbnail = "https://images.pexels.com/photos/17299534/pexels-photo-17299534/free-photo-of-pickleball-paddle-ball-court-net.jpeg?auto=compress&cs=tinysrgb&w=600";
                          }
                          Map<String, dynamic> eventData = {
                            'name': nameController.text,
                            'sport': selectedSport,
                            'location': selectedLocation,
                            'date': selectedDate.toString().substring(0, 10),
                            'time': startTime.format(context),
                            'total_participants': maxNumParticipants,
                            'current_participants': 0,
                            'thumbnail': thumbnail,
                            'description': descriptionArray,
                            "is_past": false
                          };
                          event = Event(
                            name: nameController.text,
                            sport: selectedSport,
                            location: selectedLocation,
                            date: selectedDate.toString().substring(0, 10),
                            time: startTime.format(context),
                            totalParticipants: maxNumParticipants,
                            currentParticipants: 0,
                            thumbnail: thumbnail,
                            description: descriptionArray,
                            isPast: false,
                          );
                          appendToJson(eventData);
                          Navigator.pop(context);
                          provider.addToList(event);
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
        '/assets/event_list.json');
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