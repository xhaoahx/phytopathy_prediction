import 'package:flutter/material.dart';
import 'package:phytopathy_prediction/models/chat_model.dart' as server;
import 'package:phytopathy_prediction/models/user_model.dart' as client;
import 'package:phytopathy_prediction/route.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:phytopathy_prediction/widgets/head_icon.dart';

const List<String> _descriptions = [
  "园林植物专家、古树名木专家库专家成员，从事园林植物引种、保育、养护等工作20余年。"
      "园林有害生物防控专家、古树名木专家库专家成员，从事园林有害生物防控17年。"
      "园林有害生物防控专家、从事园林有害生物防控17年"
];

final _random = Random.secure();

class ChatList extends StatefulWidget {
  static const routeName = 'chat_list';
  static Widget builder(BuildContext context) => ChatList();

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  bool _loading = false;
  bool _connectSucceed = false;

  @override
  void initState() {
    super.initState();
    _connectServer();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (_loading) {
      child = Center(child: CircularProgressIndicator());
    } else if (_connectSucceed) {
      child = _ChatListBody();
    } else {
      child = Center(
        child: Text('连接失败，请检查网络'),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('专家咨询')),
      body: child,
    );
  }

  void _connectServer() async {
    final model = context.read<server.ChatModel>();
    print('链接 socket 服务器');
    if (model.connected) {
      _connectSucceed = model.requestUserList();
    } else {
      _connectSucceed = false;
    }

    setState(() {
      _loading = false;
    });
  }
}

class _ChatListBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<server.ChatModel, Object>(
      builder: (BuildContext context, Object value, Widget? child) {
        final model = context.read<server.ChatModel>();

        final movedLocalUsers = List<server.User>.from(model.users)
          ..removeWhere(
            (value) =>
                value.username ==
                context.read<client.UserModel>().user.username,
          );

        final title = ListTile(
          leading: const SizedBox(width: 16.0,),
          title: Text(
            '用户信息',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w200,
            ),
          ),
          trailing: SizedBox(
            width: 132.0,
            child: Text(
              '用户描述',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w200,
              ),
            ),
          )
        );

        final list = ListView.builder(
          itemBuilder: (context, index) {
            final user = movedLocalUsers[index];
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(
                vertical: 4.0,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
              ),
              color: Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                ),
                leading: HeadIcon(
                  username: user.username,
                  size: 32.0,
                ),
                title: Text(
                  user.username,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                trailing: user.isExpert
                    ? SizedBox(
                  width: 164.0,
                  child: Text(
                    _descriptions[_random.nextInt(_descriptions.length)],
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w200,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
                    : null,
                onTap: () {
                  _handleTap(context, user.username);
                },
              ),
            );
          },
          itemCount: movedLocalUsers.length,
          itemExtent: 70.0,
        );

        return Column(
          children: [
            title,
            Expanded(child: list),
          ],
        );
      },
      selector: (BuildContext context, server.ChatModel model) =>
          model.usersChanged,
      shouldRebuild: (Object previous, Object next) => previous != next,
    );
  }

  void _handleTap(BuildContext context, String name) async {
    final model = context.read<server.ChatModel>();

    print('add disconnect callback');
    model.onInviteDisconnectCallback = () {
      print('on invite disconnect');
      Navigator.popUntil(context,ModalRoute.withName(Routes.chat_list));

      showDialog(context: context, builder: (context){
        return AlertDialog(title: Text('对方断开了连接'),);
      });

      model.onInviteDisconnectCallback = null;
    };

    showDialog(
      context: context,
      builder: (BuildContext innerContext) {
        return WillPopScope(
          child: AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                Text('等待确认'),
              ],
            ),
          ),
          onWillPop: () => Future.value(false),
        );
      },
      barrierDismissible: false,
    );

    final result = await model.createRoom(name);

    if (result != null) {
      Navigator.popUntil(context,ModalRoute.withName(Routes.chat_list));
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(result),
        ),
      );
    } else {
      Navigator.popUntil(context,ModalRoute.withName(Routes.chat_list));
      await Navigator.pushNamed(context, Routes.chat_details);
    }

    print('remove disconnect callback');
    model.onInviteDisconnectCallback = null;
  }
}
