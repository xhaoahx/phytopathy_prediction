import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phytopathy_prediction/models/chat_model.dart';
import 'package:phytopathy_prediction/models/phytopathy_prediction_model.dart';
import 'package:phytopathy_prediction/pages/navigation/discovery/discovery.dart';
import 'package:phytopathy_prediction/pages/navigation/home/home.dart';
import 'package:phytopathy_prediction/pages/navigation/profile/profile.dart';
import 'package:phytopathy_prediction/route.dart';
import 'package:provider/provider.dart';

class Navigation extends StatefulWidget {
  static const routeName = 'navigation';
  static Widget builder(context) => Navigation();

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  late final PageController _pageController;
  late final chatModel;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);

    chatModel = context.read<ChatModel>();
    chatModel.onReceiveInviteCallback = _showInviteDialog;
    chatModel.onCreatedRoomCallback = _openChatPage;
    WidgetsBinding.instance?.addObserver(chatModel);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(chatModel);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      leading: _TakePhotoButton(),
      title: _SearchBar(),
      centerTitle: true,
      actions: [
        _HistoryButton(),
      ],
    );

    final navigationBar = _NavigationBar();

    final scaffold = Scaffold(
      appBar: appBar,
      bottomNavigationBar: navigationBar,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          Discovery(),
          Home(),
          Profile(),
        ],
      ),
    );

    return WillPopScope(child: scaffold, onWillPop: _showQuitDialog);
  }

  Future<bool> _showQuitDialog() async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('退出App?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  SystemNavigator.pop(animated: true).then((value) => exit(0));
                },
                child: Text('确认'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context,false),
                child: Text('取消'),
              )
            ],
          );
        });
  }

  Future<bool> _showInviteDialog(String host) async {
    BuildContext? hookContext;
    final quit = Timer(
        const Duration(
          seconds: 10,
        ), () {
      Navigator.pop(hookContext!, false);
    });

    final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          hookContext = context;
          return SimpleDialog(
            children: [
              Text('收到来自$host的对话邀请'),
              TextButton(
                onPressed: () {
                  quit.cancel();
                  Navigator.pop(context, false);
                },
                child: Text('拒绝'),
              ),
              TextButton(
                onPressed: () {
                  quit.cancel();
                  Navigator.pop(context, true);
                },
                child: Text('接受'),
              ),
            ],
          );
        });
    return result ?? false;
  }

  void _openChatPage() {
    Navigator.pushNamed(context, Routes.chat_details);
  }
}

class _TakePhotoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.camera_alt,
        size: 28.0,
      ),
      onPressed: () async {
        final model =
            Provider.of<PhytopathyPredictionModel>(context, listen: false);
        final result = await model.takeImage(ImageSource.camera);

        if (result) {
          late BuildContext _hookContext;
          showDialog(
            context: context,
            builder: (context) {
              _hookContext = context;
              return AlertDialog(
                content: Row(
                  children: [
                    CircularProgressIndicator(),
                    const SizedBox(width: 20.0),
                    const Text(
                      '请稍后',
                    ),
                  ],
                ),
              );
            },
            barrierDismissible: false,
          );

          await model.prediction();
          Navigator.pop(_hookContext);
          //_hookContext = null;

          Navigator.of(context).pushNamed(Routes.phytopathy_prediction);
        }
      },
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 240.0,
        height: 28.0,
        decoration: BoxDecoration(
          //shape: BoxShape.circle,
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
        ),
        child: Align(
          heightFactor: 0.8,
          child: SizedBox(
            child: Row(
              children: [
                SizedBox(
                  width: 5.0,
                ),
                Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 8.0,
                ),
                // Expanded(
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       '搜你想要的',
                //       style: TextStyle(
                //         color: Colors.grey,
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ));
  }
}

class _HistoryButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<_NavigationBar> {
  int _current = 1;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      //elevation: 0.5,
      backgroundColor: Theme.of(context).canvasColor,
      fixedColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey.withOpacity(0.7),
      currentIndex: _current,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          label: '发现',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: '主页'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
      ],
      onTap: _handleTap,
    );
  }

  void _handleTap(int index) {
    setState(() {
      _current = index;
      context
          .findAncestorStateOfType<_NavigationState>()
          ?._pageController
          .jumpToPage(index);
    });
  }
}
