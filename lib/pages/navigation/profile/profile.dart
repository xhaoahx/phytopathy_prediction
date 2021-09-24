import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phytopathy_prediction/models/chat_model.dart' as server;
import 'package:phytopathy_prediction/models/user_model.dart' as client;
import 'package:phytopathy_prediction/widgets/head_icon.dart';
import 'package:provider/provider.dart';
import 'package:phytopathy_prediction/route.dart';

import 'dart:math';

const List<String> _features = [
  '发表话题',
  '获得点赞',
  '收到回复',
];

const List<int> _limits = [
  60,
  1500,
  200,
];

const List<String> _items = [
  '设置密码',
  '设置年龄',
  '设置性别',
  '设置联系方式',
  //'设置特征植物',
];

const List<IconData> _icons = [
  Icons.lock,
  Icons.data_usage,
  Icons.fiber_manual_record,
  Icons.phone,
  Icons.check_outlined,
];

final Random random = Random.secure();

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.read<client.UserModel>().user;
    final themeData = Theme.of(context);

    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 8.0),
        HeadIcon(username: user.username, size: 48.0),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            user.username,
            style: TextStyle(
              fontSize: 24.0,
              color: themeData.primaryColor,
            ),
          ),
        )
      ],
    );

    final feature = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(_features.length, (index) {
        return Column(
          children: [
            Text(
              random.nextInt(_limits[index]).toString(),
              style: TextStyle(
                color: Colors.black45,
                fontSize: 28.0,
              ),
            ),
            Text(
              _features[index],
              style: TextStyle(
                color: themeData.primaryColorLight,
                fontSize: 16.0,
              ),
            ),
          ],
        );
      }),
    );

    final divider = Divider();

    final item = Column(
      children: [
        for (int i = 0; i < _items.length; i += 1)
          _ProfileItem(
            name: _items[i],
            icon: _icons[i],
            onTap: () {
              _showModifyDialog(context, i);
            },
          ),
        _ProfileItem(
          name: '问题反馈',
          icon: Icons.question_answer,
          onTap: () {
            Navigator.pushNamed(context, Routes.consult);
          },
        ),
        _ProfileItem(
          name: '退出登录',
          icon: Icons.close,
          onTap: () {
            _quit(context);
          },
        )
      ],
    );

    return Container(
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
        ),
        children: [
          const SizedBox(height: 40.0),
          header,
          const SizedBox(height: 32.0),
          feature,
          const SizedBox(height: 32.0),
          divider,
          const SizedBox(height: 12.0),
          item,
        ],
      ),
    );
  }

  void _showModifyDialog(BuildContext context, int index) async {
    final model = context.read<client.UserModel>();
    assert(index >= 0 && index < _items.length);

    client.User current = model.user;
    client.User? info;
    final controller = TextEditingController();

    final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('修改${_items[index]}'),
            content: TextField(
              controller: controller,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  switch (index) {
                    case 0:
                      info = current.copyWith(password: controller.text);
                      break;
                    case 1:
                      info = current.copyWith(
                          age: int.tryParse(controller.text) ?? 0);
                      break;
                    case 2:
                      info = current.copyWith(gender: controller.text);
                      break;
                    case 3:
                      info = current.copyWith(phone: controller.text);
                      break;
                    // case 4:
                    //   info = current.copyWith(plant: controller.text);
                    //   break;
                  }
                  Navigator.pop(context, true);
                },
                child: Text('确认'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('取消'),
              ),
            ],
          );
        });

    if (result != null && result) {
      assert(info != null);
      final canModify = await model.updateUserInfo(info!);

      if (canModify) {
        showToast('修改${_items[index]}成功！');
      } else {
        showToast('修改${_items[index]}失败！');
      }
    }
  }

  void _quit(BuildContext context) {
    context.read<client.UserModel>().quit();
    context.read<server.ChatModel>().disconnectServer();
    Navigator.pushReplacementNamed(context, Routes.splash);
  }
}

class _ProfileItem extends StatelessWidget {
  _ProfileItem({
    required this.name,
    required this.icon,
    required this.onTap,
  });

  final String name;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialButton(
      onPressed: onTap,
      child: Row(
        children: [
          Icon(icon,color: theme.primaryColor,size: 20.0),
          const SizedBox(width: 8.0),
          Text(name),
        ],
      ),
    );
  }
}
