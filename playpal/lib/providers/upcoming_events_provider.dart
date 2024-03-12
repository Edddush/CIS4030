import 'package:flutter/widgets.dart';
import 'package:playpal/src/event_feature/event.dart';

class UpcomingEventsProvider extends ChangeNotifier{
  final List<Event> _events = [];
  List<Event> get events => _events;

  Future<void> addToList(Event event) async {
    if (isUpcomingEvent(event) == false) {
      _events.add(event);
      notifyListeners();
    }
  }

  Future<void> removeFromList(Event event) async {
    if(isUpcomingEvent(event)){
      _events.remove(event);
      notifyListeners();
    }
  }

  bool isUpcomingEvent(Event event){
    return _events.contains(event);
  }
}
