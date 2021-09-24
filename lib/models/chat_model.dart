import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:phytopathy_prediction/common/error_handler.dart';
import 'package:phytopathy_prediction/objects/dao/event/event.dart';
import 'package:phytopathy_prediction/objects/dao/object.dart';

export 'package:phytopathy_prediction/objects/dao/object.dart';

String _encodeEvent(Event event) => jsonEncode(event.toJson());

//final _url = 'ws://127.0.0.1:8082';
//final _url = 'ws://192.168.43.162:8082';
final _url = 'ws://47.94.169.41:8082';

enum _State {
  out_room,
  waiting,
  in_room,
}

class ChatModel extends ChangeNotifier with WidgetsBindingObserver {
  WebSocket? _socket;

  _State _state = _State.out_room;
  AppLifecycleState _lifecycleState = AppLifecycleState.resumed;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 监听生命周期的变化
    _lifecycleState = state;
    print('liftState change to $_lifecycleState');
  }

  /// Global
  bool get connected => _connected;
  bool _connected = false;

  String get localUser => _localUser!;
  String? _localUser;

  Object get usersChanged => _usersChanged;
  Object _usersChanged = Object();

  List<User> get users => _users;
  final List<User> _users = List.empty(growable: true);

  bool get isInviting => _createRoomCompleter != null;
  Completer<String?>? _createRoomCompleter;

  set onReceiveInviteCallback(Future<bool> Function(String host)? callback) =>
      _onReceiveInviteCallback = callback;
  Future<bool> Function(String host)? _onReceiveInviteCallback;

  set onCreatedRoomCallback(VoidCallback? callback) =>
      _onCreatedRoomCallback = callback;
  VoidCallback? _onCreatedRoomCallback;

  set onInviteDisconnectCallback(VoidCallback? callback) =>
      _onInviteDisconnectCallback = callback;
  VoidCallback? _onInviteDisconnectCallback;

  /// Room
  bool get roomCreated => _roomHash != null;
  int? _roomHash;

  String get remoteUser => _remoteUser!;
  String? _remoteUser;

  Object get messagesChanged => _messagesChanged;
  Object _messagesChanged = Object();

  List<Message> get messages => _messages;
  final List<Message> _messages = List.empty(growable: true);

  set onRemoteUserDisconnect(VoidCallback? callback) =>
      _onRemoteUserDisconnect = callback;
  VoidCallback? _onRemoteUserDisconnect;

  /// Public method
  Future<bool> connectServer(String username, bool isExpert) async {
    print('以$username<$isExpert>链接服务器：');
    try {
      _socket = await WebSocket.connect(_url).catchError((e, s) {
        errorPrintHandler(e, s);
      });
    } catch (e, s) {
      errorPrintHandler(e, s);
      _socket = null;
      return false;
    }

    assert(_socket != null);

    _socket!.listen((event) {
      _handleEvent(event, _socket!);
    }, onDone: () {
      _socket!.close();
    });

    _emitConnectEvent(username, isExpert);
    _localUser = username;

    _connected = true;
    notifyListeners();
    return true;
  }

  void disconnectServer() async {
    await _socket?.close();
    _socket = null;

    _localUser = null;
    _users.clear();

    _usersChanged = Object();
    _connected = false;
  }

  // called when page dispose
  void leaveRoom() {
    print('leave room');
    _emitLeaveRoomEvent();

    _clearRoom();
  }

  bool requestUserList() => _emitRequestUserListEvent();

  void sendMessage(String message) {
    assert(_state == _State.in_room);
    _emitMessageEvent(Message(
      srcUsername: _localUser!,
      dstUsername: _remoteUser!,
      content: message,
      roomHash: _roomHash!,
    ));
  }

  Future<String?> createRoom(String username) async {
    assert(_state == _State.out_room);
    _state = _State.waiting;
    _createRoomCompleter = Completer();
    _emitCreateRoomEvent(username);
    return _createRoomCompleter!.future;
  }

  /// handle event
  void _handleReturnUserListEvent(ReturnUserListEvent event) {
    print('当前用户列表');
    event.users.forEach(print);

    _users.clear();
    _users.addAll(event.users);
    _usersChanged = new Object();

    notifyListeners();
  }

  void _handleInviteGuestEvent(InviteGuestEvent event) async {
    assert(event.info.guest == _localUser);

    late Agreement agreement;

    if (_lifecycleState != AppLifecycleState.resumed) {
      agreement = Agreement.busy;
    } else if (_state == _State.in_room || _state == _State.waiting) {
      agreement = Agreement.busy;
    } else {
      assert(_state == _State.out_room);
      _state = _State.waiting;
      final result = await _onReceiveInviteCallback!(event.info.host);

      agreement = result ? Agreement.agree : Agreement.refuse;

      if (result) {
        _remoteUser = event.info.host;
        assert(_createRoomCompleter == null);
        _createRoomCompleter = Completer()
          ..future.then((value) {
            _onCreatedRoomCallback?.call();
          });
      } else {
        assert(_state == _State.waiting);
        _state = _State.out_room;
      }
    }

    _socket?.add(
      _encodeEvent(
        InviteResponseEvent(
          InviteResponseInfo(
            agreement: agreement.index,
            hash: event.info.hash,
          ),
        ),
      ),
    );
  }

  void _handleCreatedRoomEvent(CreatedRoomEvent event) {
    assert(_state == _State.waiting);
    assert(_createRoomCompleter != null);

    _roomHash = event.roomHash;
    _state = _State.in_room;
    print('${_localUser!} 和 ${_remoteUser!} 进入房间 ${_roomHash!}');

    _createRoomCompleter!.complete(null);
    _createRoomCompleter = null;
  }

  void _handleCreateRoomFailedEvent(CreateRoomFailedEvent event) {
    if (_state == _State.in_room) return;
    if (_state == _State.out_room) return;
    if(_lifecycleState != AppLifecycleState.resumed) return;

    assert(_createRoomCompleter != null);

    late String reason;
    final agreement = event.agreement;

    if (agreement == Agreement.refuse.index) {
      reason = '对方拒绝了邀请';
    } else if (agreement == Agreement.busy.index) {
      reason = '对方正忙';
    } else if (agreement == Agreement.not_exists.index){
      reason = '用户已经离线';
    }

    _state = _State.out_room;
    _createRoomCompleter!.complete(reason);
    _createRoomCompleter = null;

    _clearRoom();
  }

  void _handleMessageEvent(MessageEvent event) {
    _messages.add(event.message);
    _messagesChanged = new Object();
    notifyListeners();
  }

  void _handleUserDisconnectEvent(UserDisconnectEvent event) {
    print('user disconnect: ${event.user}');

    if (_state == _State.waiting) {
      if (event.user == _remoteUser) {
        print('user disconnect when waiting');
        _onInviteDisconnectCallback?.call();
        _clearRoom();
      }
    } else {
      assert(_state == _State.in_room);
      if (event.user == _remoteUser) {
        _onRemoteUserDisconnect?.call();
        _clearRoom();
        _state = _State.out_room;
      }
    }

    _emitRequestUserListEvent();
  }

  void _handleEvent(dynamic event, WebSocket socket) {
    Event eventClass;
    if (event is String) {
      try {
        //print(event);
        final json = jsonDecode(event) as Map<String, dynamic>;
        eventClass = Event.fromJson(json);
      } catch (e, s) {
        print('error $e,stack $s');
        throw ArgumentError.value(event);
      }
    } else {
      print('消息类型错误，转换失败');
      throw ArgumentError(event.runtimeType.toString());
    }

    if (isMessageEvent(eventClass)) {
      _handleMessageEvent(MessageEvent.fromEvent(eventClass));
    }

    // if (isUserConnectEvent(eventClass)) {
    //   _handleUserConnectListEvent(UserConnectEvent.fromEvent(eventClass));
    // }

    if (isUserDisconnectEvent(eventClass)) {
      _handleUserDisconnectEvent(UserDisconnectEvent.fromEvent(eventClass));
    }

    if (isReturnUserListEvent(eventClass)) {
      _handleReturnUserListEvent(ReturnUserListEvent.fromEvent(eventClass));
    }

    if (isInviteGuestEvent(eventClass)) {
      _handleInviteGuestEvent(InviteGuestEvent.fromEvent(eventClass));
    }

    if (isCreatedRoomEvent(eventClass)) {
      _handleCreatedRoomEvent(CreatedRoomEvent.fromEvent(eventClass));
    }

    if (isCreateRoomFailedEvent(eventClass)) {
      _handleCreateRoomFailedEvent(CreateRoomFailedEvent.fromEvent(eventClass));
    }
  }

  /// Emit event
  bool _emitMessageEvent(Message message) {
    if (_socket == null) {
      return false;
    }
    _socket!.add(_encodeEvent(MessageEvent(message)));

    _messages.add(message);
    _messagesChanged = Object();

    notifyListeners();
    return true;
  }

  bool _emitConnectEvent(String username, bool isExpert) {
    if (_socket == null) {
      return false;
    }

    print('发送连接事件');
    _socket!.add(
      _encodeEvent(
        ConnectEvent(
          User(
            username: username,
            isExpert: isExpert,
          ),
        ),
      ),
    );
    return true;
  }

  bool _emitRequestUserListEvent() {
    print('请求用户列表');
    if (_socket == null) {
      return false;
    }
    _socket!.add(_encodeEvent(RequestUserListEvent()));
    return true;
  }

  bool _emitCreateRoomEvent(String username) {
    assert(_localUser != null);
    assert(_remoteUser == null);

    _remoteUser = username;
    if (_socket != null) {
      _socket!.add(
        _encodeEvent(
          CreateRoomEvent(
            RoomInfo(
              host: _localUser!,
              guest: username,
              hash: 0,
            ),
          ),
        ),
      );
      return true;
    }
    return false;
  }

  void _emitLeaveRoomEvent() {
    _socket?.add(
      _encodeEvent(
        LeaveRoomEvent(
          RoomInfo(
            host: _localUser!,
            guest: _remoteUser!,
            hash: _roomHash!,
          ),
        ),
      ),
    );
  }

  /// Private method
  void _clearRoom() {
    _remoteUser = null;
    _roomHash = null;
    _onRemoteUserDisconnect = null;

    _messages.clear();
    _messagesChanged = Object();
    _state = _State.out_room;
  }
}
