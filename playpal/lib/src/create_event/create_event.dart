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
  DateTime? selectedDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  int maxNumParticipants = 0;
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<String> sports = ['Basketball', 'Hockey', 'Pickleball', 'Soccer', 'Squash', 'Tennis', "Volleyball"];
  TextEditingController numberController = TextEditingController();

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
                      maxNumParticipants = int.parse(value);
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
                        if (formKey.currentState != null && formKey.currentState!.validate()) {
                          List<String> descriptionArray = descriptionController.text.split(',').map((e) => e.trim()).toList();
                          Event event;
                          String thumbnail = "";
                          if (selectedSport == "Basketball"){
                            thumbnail = "https://cdn.pixabay.com/photo/2013/07/12/14/07/basketball-147794_960_720.png";
                          }else if (selectedSport == "Soccer"){
                            thumbnail = "https://cdn.pixabay.com/photo/2013/07/13/10/51/football-157930_960_720.png";
                          }else if (selectedSport == "Tennis"){
                            thumbnail = "https://cdn.pixabay.com/photo/2017/01/31/15/31/tennis-2025095_960_720.png";
                          }else if (selectedSport == "Hockey"){
                            thumbnail = "https://pixabay.com/get/ge8fac783f06255bb3445a38e94ec10c2dc5b5d0003df4945ce54d828a6770504d4eb4cd0ae7d9e376403ba0a6b402089_1280.png";
                          }else if (selectedSport == "Squash"){
                            thumbnail = "https://pixabay.com/get/g367fef0b1a821e795d9d1d873e69dad54cf5284f600d475532a6e6f8683e42ce54841e67dea1525c2f1f6a9c30be768e_1280.png";
                          }else if (selectedSport == "Volleyball"){
                            thumbnail = "https://pixabay.com/get/gfa800b58c884f9746b7833bc48741ad80321a50eb469991570ac0552a14fb7cc4746eb463e420f30591d1ef89504df942cb4a86f604eaff1127bb0ee3d3998f1_1280.png";
                          }else if (selectedSport == "PickelBall"){
                            thumbnail = "https://pixabay.com/get/g6e58591ab62e3a1dd8bae7037148c02d10b6bf76c53cf43bbd0f5faca0fcc837590590599270942f64d4caa8bd3f2242de27947fc5f6d3b3330d6afe0a5628d1_1280.png";
                          }
                          Map<String, dynamic> eventData = {
                            'name': nameController.text,
                            'sport': selectedSport,
                            'location': locationController.text,
                            'date': selectedDate.toString().substring(0, 10),
                            'time': startTime.format(context),
                            'total_participants': maxNumParticipants,
                            'current_participants': 0,
                            'thumbnail': thumbnail,
                            'description': descriptionArray,
                            "isPast": false
                          };
                          event = Event(
                            name: nameController.text,
                            sport: selectedSport,
                            location: locationController.text,
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