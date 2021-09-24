
import '../message.dart';
import 'basic_event.dart';

class MessageEvent extends Event{
  MessageEvent(Message message) : super(eventType: _eventName,data: message);

  factory MessageEvent.fromEvent(Event event){
    return MessageEvent(Message.fromJson(event.data as Map<String,dynamic>));
  }

  Message get message => data as Message;

  @override
  Map<String,dynamic> toJson(){
    return <String, dynamic>{
      'eventType': _eventName,
      'data': message.toJson(),
    };
  }

  static const _eventName = 'message';
}

bool isMessageEvent(Event event) => event.eventType ==  MessageEvent._eventName;