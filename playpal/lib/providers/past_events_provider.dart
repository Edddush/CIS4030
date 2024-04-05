import 'package:flutter/widgets.dart';
import 'package:playpal/src/event_feature/event.dart';

class PastEventsProvider extends ChangeNotifier{
  final List<EventObject > _events = [];
  List<EventObject > get events => _events;

  Future<void> addToList(EventObject event) async {
    if (_isPastEvent(event) == false) {
      _events.add(event);
      notifyListeners();
    }
  }

  Future<void> removeFromList(EventObject event) async {
    if(_isPastEvent(event)){
      _events.remove(event);
      notifyListeners();
    }
  }

  bool _isPastEvent(EventObject event){
    return _events.contains(event);
  }
}
