import 'package:flutter/widgets.dart';
import 'package:playpal/src/event_feature/event.dart';

class MyEventsProvider extends ChangeNotifier {
  final List<Event> _events = [];
  List<Event> get events => _events;

  Future<void> addToList(Event event) async {
    if (_isMyEvent(event) == false) {
      _events.add(event);
      notifyListeners();
    }
  }

  Future<void> removeFromList(Event event) async{
    if (_isMyEvent(event)) {
      _events.remove(event);
      notifyListeners();
    }
  }

  bool _isMyEvent(Event event) {
    return _events.contains(event);
  }
}
