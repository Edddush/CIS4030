import 'package:flutter/widgets.dart';
import 'package:playpal/src/event_feature/event.dart';

class MyEventsProvider extends ChangeNotifier {
  final List<EventObject> _eventObjects = [];
  List<EventObject> get eventObjects => _eventObjects;

  Future<void> addToList(EventObject eventObject) async {
    if (_isMyEvent(eventObject) == false) {
      _eventObjects.add(eventObject);
      notifyListeners();
    }
  }

  Future<void> removeFromList(EventObject eventObject) async{
    if (_isMyEvent(eventObject)) {
      _eventObjects.remove(eventObject);
      notifyListeners();
    }
  }

  bool _isMyEvent(EventObject eventObject) {
    return _eventObjects.contains(eventObject);
  }
}
