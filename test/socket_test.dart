import 'package:flutter_test/flutter_test.dart';
import 'package:web_socket_channel/io.dart';

void main(){
  group('socket', (){
    test('test 1 : connect',() async {
      final channel = IOWebSocketChannel.connect(
        'ws://47.94.169.41:8000',
      );

      await Future.delayed(const Duration(milliseconds: 1000));
      //
      print('send message');
      //
      channel.sink.add('hello');
      //
      // channel.stream.listen(print);

      channel.sink.close();

      print('end');
    });
  });
}