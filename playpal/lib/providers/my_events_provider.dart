import 'package:flutter/widgets.dart';
import 'package:playpal/src/event_feature/event.dart';

class MyEventsProvider extends ChangeNotifier{
  final List<Event> _events = [];
  List<Event> get events => _events;

  void addtoList(Event event){
    _events.add(event);
    notifyListeners();
  }

  void removeFromList(Event event){
    if(isMyEvent(event)){
      _events.remove(event);
    }
  }

  bool isMyEvent(Event event){
    return _events.contains(event);
  }
}
