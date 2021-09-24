import '../object.dart';
import 'basic_event.dart';

class ConnectEvent extends Event {
  ConnectEvent(User user) : super(eventType: _eventName, data: user);

  factory ConnectEvent.fromEvent(Event event) =>
      ConnectEvent(User.fromJson(event.data as Map<String, dynamic>));

  User get user => data as User;

  static const _eventName = 'connect';
}

bool isConnectEvent(Event event) => event.eventType == ConnectEvent._eventName;

class UserDisconnectEvent extends Event {
  UserDisconnectEvent(String user) : super(eventType: _eventName, data: user);

  factory UserDisconnectEvent.fromEvent(Event event) =>
      UserDisconnectEvent(event.data as String);

  String get user => data as String;

  static const _eventName = 'user_disconnect';
}

bool isUserDisconnectEvent(Event event) =>
    event.eventType == UserDisconnectEvent._eventName;

class UserConnectEvent extends Event {
  UserConnectEvent(User user) : super(eventType: _eventName, data: user);

  factory UserConnectEvent.fromEvent(Event event) =>
      UserConnectEvent(User.fromJson(event.data as Map<String, dynamic>));

  User get user => data as User;

  static const _eventName = 'user_connect';
}

bool isUserConnectEvent(Event event) =>
    event.eventType == UserConnectEvent._eventName;
