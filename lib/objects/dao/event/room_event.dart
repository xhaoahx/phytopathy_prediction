import '../object.dart';
import 'basic_event.dart';

class CreateRoomEvent extends Event {
  CreateRoomEvent(RoomInfo info)
      : super(
          eventType: _eventName,
          data: info.toJson(),
        );

  factory CreateRoomEvent.fromEvent(Event event) =>
      CreateRoomEvent(RoomInfo.fromJson(event.data as Map<String, dynamic>));

  RoomInfo get info => RoomInfo.fromJson(data as Map<String, dynamic>);
  static const _eventName = 'create_room';
}

bool isCreateRoomEvent(Event event) =>
    event.eventType == CreateRoomEvent._eventName;

class InviteGuestEvent extends Event {
  InviteGuestEvent(RoomInfo info)
      : super(eventType: _eventName, data: info.toJson());

  factory InviteGuestEvent.fromEvent(Event event) =>
      InviteGuestEvent(RoomInfo.fromJson(event.data as Map<String, dynamic>));

  RoomInfo get info => RoomInfo.fromJson(data as Map<String, dynamic>);
  static const _eventName = 'invite_guest';
}

bool isInviteGuestEvent(Event event) =>
    event.eventType == InviteGuestEvent._eventName;

class InviteResponseEvent extends Event {
  InviteResponseEvent(InviteResponseInfo info)
      : super(eventType: _eventName, data: info.toJson());

  factory InviteResponseEvent.fromEvent(Event event) => InviteResponseEvent(
      InviteResponseInfo.fromJson(event.data as Map<String, dynamic>));

  InviteResponseInfo get info =>
      InviteResponseInfo.fromJson(data as Map<String, dynamic>);
  static const _eventName = 'invite_response';
}

bool isInviteResponseEvent(Event event) =>
    event.eventType == InviteResponseEvent._eventName;

class CreatedRoomEvent extends Event {
  CreatedRoomEvent(int hash)
      : super(
          eventType: _eventName,
          data: hash,
        );

  factory CreatedRoomEvent.fromEvent(Event event) =>
      CreatedRoomEvent(event.data as int);

  int get roomHash => data as int;
  static const _eventName = 'created_room';
}

bool isCreatedRoomEvent(Event event) =>
    event.eventType == CreatedRoomEvent._eventName;

class EnterRoomEvent extends Event {
  EnterRoomEvent() : super(eventType: _eventName);

  factory EnterRoomEvent.fromEvent(Event _) => EnterRoomEvent();

  static const _eventName = 'enter_room';
}

bool isEnterRoomEvent(Event event) =>
    event.eventType == EnterRoomEvent._eventName;

class LeaveRoomEvent extends Event {
  LeaveRoomEvent(RoomInfo info)
      : super(eventType: _eventName, data: info.toJson());

  factory LeaveRoomEvent.fromEvent(Event event) => LeaveRoomEvent(
        RoomInfo.fromJson(event.data as Map<String, dynamic>),
      );

  RoomInfo get info => RoomInfo.fromJson(data as Map<String, dynamic>);

  static const _eventName = 'leave_room';
}

bool isLeaveRoomEvent(Event event) =>
    event.eventType == LeaveRoomEvent._eventName;

class CreateRoomFailedEvent extends Event {
  CreateRoomFailedEvent(int agreement)
      : super(eventType: _eventName, data: agreement);

  factory CreateRoomFailedEvent.fromEvent(Event event) => CreateRoomFailedEvent(
        event.data as int,
      );

  int get agreement => data as int;

  static const _eventName = 'create_room_result_failed';
}

bool isCreateRoomFailedEvent(Event event) =>
    event.eventType == CreateRoomFailedEvent._eventName;
