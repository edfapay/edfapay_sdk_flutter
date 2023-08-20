import 'dart:convert';

class Event{
  static String OnCardProcessingComplete = "onCardProcessingComplete";
  static String OnRequestTimerEnd = "onRequestTimerEnd";
  static String OnCardScanTimerEnd = "onCardScanTimerEnd";

  final String event;
  final List? parameters;

  Event(this.event, this.parameters);

  static Event fromJson(String json){
    final map = jsonDecode(json);
    return Event(
        map["event"],
        map["parameters"] as List
    );
  }
  static Event fromMap(Map map){
    return Event(
        map["event"],
        map["parameters"]
    );
  }
}