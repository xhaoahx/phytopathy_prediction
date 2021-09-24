import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phytopathy_prediction/objects/user.dart';


const username = 'root';
const password = '123';

void main() {
  group('service test', () {
    final url = 'http://47.94.169.41:8081/';
    final dio = Dio(
      BaseOptions(
        baseUrl: url,
      ),
    );

    test('test 1 : register', () async {
      final result = await dio.post(
        'register/',
        data: FormData.fromMap({
          'username': username,
          'password': password,
          'age': -1,
          'gender': 'man',
          'phone': '123123123121',
          'plant': '苏巴纳希',
        }),
      );

      print(result);


    });

    test('test 2 : login succeed', () async {
      final result = await dio.post(
        'login/',
        data: FormData.fromMap({
          'username': username,
          'password': password,
        }),
      );

      print(result.data);

      final json = result.data as Map<String,dynamic>;

      print(json['username']);

      print(User.fromJson(result.data));
    });

    test('test 3 : login failed', () async {
      final result = await dio.post(
        'login/',
        data: FormData.fromMap({
          'username': username,
          'password': '1231231',
        }),
      );

      print(result.data);

      final json = result.data as Map<String,dynamic>;

      print(json['username']);

      //print(User.fromJson(result.data));
    });
  });
}
