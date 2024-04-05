import 'package:flutter/material.dart';
import 'event_list_view.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as dateTimePicker;
import 'package:animated_text_kit/animated_text_kit.dart'; // Ensure this import is added for animations
import 'event_list_view.dart'; // Import your EventListView page
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as datatTimePicker;
import 'package:intl/intl.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController password2Controller = TextEditingController();
  DateTime? selectedDate = DateTime.now();

  void _signUp() {
    // Placeholder for your sign-up logic
    Map<String, dynamic> userData = {
      'username': usernameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'dob': DateFormat('yyyy-MM-dd').format(selectedDate!)
    };
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EventListView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'PlayPal',
              textStyle: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
              speed: const Duration(milliseconds: 200),
            ),
          ],
          totalRepeatCount: 4,
          pause: const Duration(milliseconds: 1000),
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: password2Controller,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Re-enter Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => showDatePicker(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20.0),
                  ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a unique username';
                }
                return null;
              },
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the password.';
                } else if (value != password2Controller.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            TextFormField(
              controller: password2Controller,
              decoration: const InputDecoration(
                labelText: 'Re-enter Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please re-enter the password.';
                } else if (value != passwordController.text) {
                  return 'Passwords do not match';
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
                  labelText: 'Date of birth',
                  hintText: 'Select Date',
                ),
                child: Text(
                  DateFormat('yyyy-MM-dd').format(selectedDate!),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    _signUp();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    backgroundColor: Colors.cyan[900],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],

        ),
      ),
    )]))));
  }

  void showDatePicker(BuildContext context) {
    dateTimePicker.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1900, 1, 1),
      maxTime: DateTime.now(),
      onConfirm: (date) {
        setState(() {
          selectedDate = date;
        });
      },
      currentTime: selectedDate,
      locale: dateTimePicker.LocaleType.en,
    );
  }
}
