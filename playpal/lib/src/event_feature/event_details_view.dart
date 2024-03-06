import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class EventDetailsView extends StatelessWidget {
  const EventDetailsView({super.key});

  static const routeName = '/event_details';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
