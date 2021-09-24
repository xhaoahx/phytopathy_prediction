import '../user.dart';
import 'basic_event.dart';

class RequestUserListEvent extends Event {
  RequestUserListEvent() : super(eventType: _eventName, data: null);
  factory RequestUserListEvent.fromEvent(Event _) => RequestUserListEvent();

  static const _eventName = 'request_user_list';
}

bool isRequestUserListEvent(Event event) =>
    event.eventType == RequestUserListEvent._eventName;

class ReturnUserListEvent extends Event {
  ReturnUserListEvent(List<User> users)
      : super(eventType: _eventName, data: users);

  factory ReturnUserListEvent.fromEvent(Event event) {
    final list = event.data as List;
    return ReturnUserListEvent(
      list.map<User>((json) => User.fromJson(json as Map<String,dynamic>)).toList(),
    );
  }

  static const _eventName = 'return_user_list';

  List<User> get users => data as List<User>;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'eventType': _eventName,
      'data': (data as List<User>).map((e) => e.toJson()).toList(),
    };
  }
}

bool isReturnUserListEvent(Event event) =>
    event.eventType == ReturnUserListEvent._eventName;
