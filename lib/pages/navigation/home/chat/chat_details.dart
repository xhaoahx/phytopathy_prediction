import 'package:flutter/material.dart';
import 'package:phytopathy_prediction/models/chat_model.dart';
import 'package:provider/provider.dart';

import 'package:phytopathy_prediction/widgets/head_icon.dart';

class ChatDetails extends StatelessWidget {
  static const routeName = 'chat_details';
  static Widget builder(BuildContext context) => ChatDetails();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('在线咨询'),
      ),
      body: _ChatDetailsBody(),
    );
  }
}

class _ChatDetailsBody extends StatefulWidget {
  @override
  __ChatDetailsBodyState createState() => __ChatDetailsBodyState();
}

class __ChatDetailsBodyState extends State<_ChatDetailsBody> {
  late ChatModel _model;

  @override
  void initState() {
    super.initState();

    _model = context.read<ChatModel>();
    _model.onRemoteUserDisconnect = _handleRemoteUserDisconnect;
  }

  @override
  void dispose() {
    _model.leaveRoom();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _MessageList()),
        _InputField(),
      ],
    );
  }

  void _handleRemoteUserDisconnect() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              '对方已经断开链接',
            ),
          );
        }).then((value) {
      Navigator.pop(context);
    });
  }
}

class _MessageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<ChatModel, Object>(
      builder: (context, value, child) {
        final model = context.read<ChatModel>();

        final local = model.localUser;
        final messages = model.messages.reversed.toList(growable: false);
        final length = messages.length;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          itemBuilder: (context, index) {
            final message = messages[index];
            print(message);

            return _ChatDialog(
              username: message.srcUsername,
              content: message.content,
              isLocal: message.srcUsername == local,
            );
          },
          itemCount: length,
          reverse: true,
        );
      },
      selector: (BuildContext context, ChatModel model) =>
          model.messagesChanged,
      shouldRebuild: (Object previous, Object next) => previous != next,
    );
  }
}

class _InputField extends StatefulWidget {
  @override
  __InputFieldState createState() => __InputFieldState();
}

class __InputFieldState extends State<_InputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final button = MaterialButton(
      color: Theme.of(context).primaryColorLight,
      onPressed: _handleSendMessage,
      child: Container(
        height: 30.0,
        alignment: Alignment.center,
        child: Text(
          '发送',
          style: TextStyle(
            color: Colors.black38,
            fontSize: 20.0,
            fontWeight: FontWeight.w300,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    );

    final input = Container(
      child: TextField(
        //scrollPadding: const EdgeInsets.all(10.0),
        autofocus: true,
        controller: _controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 6.0,
          ),
        ),
        //textAlignVertical: TextAlignVertical.center,
        maxLines: 4,
        minLines: 1,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Theme.of(context).canvasColor,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 12.0,
      ),
    );

    final bottomBar = Container(
      //height: 60.0,
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          Expanded(
            child: input,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SizedBox(
              width: 80.0,
              child: button,
            ),
          )
        ],
      ),
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 120.0,
      ),
      child: bottomBar,
    );
  }

  void _handleSendMessage() {
    final model = context.read<ChatModel>();
    print('发送消息：${_controller.text}');
    model.sendMessage(_controller.text);
    _controller.text = '';
  }
}

class _ChatDialog extends StatelessWidget {
  _ChatDialog({
    required this.username,
    required this.content,
    required this.isLocal,
  });

  final String username;
  final String content;
  final bool isLocal;

  @override
  Widget build(BuildContext context) {
    final headIcon = HeadIcon(username: username, size: 32.0);

    final dialog = Column(
      crossAxisAlignment: isLocal ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 3.0),
        Text(username),
        const SizedBox(height: 3.0),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 16.0,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12.0),
          ),
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text(
            content,
            textAlign: TextAlign.start,
          ),
        )
      ],
    );

    final child = Row(
      mainAxisAlignment:
          isLocal ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isLocal) headIcon,
        Expanded(
          child: Align(
            alignment: isLocal ? Alignment.centerRight : Alignment.centerLeft,
            child: dialog,
          ),
        ),
        if (isLocal) headIcon,
      ],
    );

    return Padding(
      child: child,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
    );
  }
}
