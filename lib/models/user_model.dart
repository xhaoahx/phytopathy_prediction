import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/error_handler.dart';
import '../objects/store_key.dart';
import '../objects/user.dart';
import 'network.dart';

export '../objects/user.dart';

class UserModel with ChangeNotifier {
  User get user {
    assert(_logged);
    return _user!;
  }

  User? _user;

  User? get savedUser => _savedUser;
  User? _savedUser;

  bool get logged => _logged;
  bool _logged = false;

  bool get expert => _expert;
  bool _expert = false;

  Future<void> loadUser() async {
    print('load user');
    final sp = await SharedPreferences.getInstance();
    final string = sp.getString(SAVED_USER_KEY);

    if (string != null) {
      try {
        _savedUser = User.fromJson(jsonDecode(string));
        print(_savedUser);
        notifyListeners();
      } catch (e, s) {
        errorPrintHandler(e, s);
        //return null;
      }
    } else {
      //return null;
    }
  }

  Future<bool> saveUser() async {
    if (!logged) {
      return false;
    }

    print('save user ${user.username}');
    final sp = await SharedPreferences.getInstance();
    final string = jsonEncode(user.toJson());
    print('saved string $string');
    sp.setString(SAVED_USER_KEY, string);

    return true;
  }

  Future<bool> register(User info) async {
    final result = await Network.instance.post(
      'register/',
      data: FormData.fromMap(info.toJson()),
    );

    print('register result: $result');

    if (result['result'] == 'register success') {
      return true;
    }
    return false;
  }

  Future<bool> login(String username, String password,
      [bool asExpert = false]) async {
    final data = await Network.instance.post('login/',
        data: FormData.fromMap({
          'username': username,
          'password': password,
        }));

    print(data);

    if (data == null) {
      return false;
    }

    try {
      _user = User.fromJson(data as Map<String, dynamic>);
      print(_user);
    } catch (e, s) {
      errorPrintHandler(e, s);
      return false;
    }

    _expert = asExpert;
    _logged = true;
    saveUser();

    return true;
  }

  void quit() {
    _user = null;
    _savedUser = null;
    _logged = false;
    _expert = false;
  }

  Future<bool> updateUserInfo(User user) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }
}
