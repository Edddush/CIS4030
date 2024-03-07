import 'package:flutter/widgets.dart';
import 'package:playpal/src/event_feature/event.dart';

class PastEventsProvider extends ChangeNotifier{
  final List<Event> _events = [];
  List<Event> get events => _events;

  void addtoList(Event event){
    _events.add(event);
    notifyListeners();
  }

  void removeFromList(Event event){
    if(isPastEvent(event)){
      _events.remove(event);
    }
  }

  bool isPastEvent(Event event){
    return _events.contains(event);
  }
}
