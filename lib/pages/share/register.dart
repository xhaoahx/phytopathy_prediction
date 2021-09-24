import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phytopathy_prediction/models/user_model.dart';
import 'package:phytopathy_prediction/objects/user.dart';
import 'package:provider/provider.dart';

const _hintInfo = [
  '用户名',
  '密码',
  '年龄',
  '性别',
  '联系方式',
  //'选择植物'
];

class Register extends StatelessWidget {
  static const routeName = 'register';
  static Widget builder(BuildContext context) => Register();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注册账号'),
      ),
      body: _RegisterContent(),
    );
  }
}

class _RegisterContent extends StatefulWidget {
  @override
  __RegisterContentState createState() => __RegisterContentState();
}

class __RegisterContentState extends State<_RegisterContent> {
  late final List<TextEditingController> _controllers;
  final _registerFormKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_hintInfo.length, (index) {
      return TextEditingController();
    });
  }

  @override
  void dispose() {
    _controllers.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  Widget _buildTextField(BuildContext context, int index, bool checkEmpty) {
    return Container(
      height: 54.0,
      padding: const EdgeInsets.symmetric(
        horizontal: 27.0,
        vertical: 2.0,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 15.0,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: _hintInfo[index],
          border: InputBorder.none,
        ),
        controller: _controllers[index],
        validator: checkEmpty
            ? (value) {
                if (value == null || value.isEmpty) {
                  return '${_hintInfo[index]}不能为空';
                }
                return null;
              }
            : null,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27.0),
        border: Border.all(color: Colors.grey.withOpacity(0.3),width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final button = Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 24.0,
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        color: Theme.of(context).primaryColor,
        onPressed: _isLoading ? null : _handleRegister,
        child: SizedBox(
          height: 50.0,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              '注册',
            ),
          ),
        ),
      ),
    );

    final child = Form(
      key: _registerFormKey,
      child: ListView(
        children: [
          for (int i = 0; i < _hintInfo.length; i++) _buildTextField(context, i,i < 2),
          button,
        ],
      ),
    );

    return AbsorbPointer(
      absorbing: _isLoading,
      child: child,
    );
  }

  Future<void> _handleRegister() async {
    final userInfo = User(
      username: _controllers[0].text,
      password: _controllers[1].text,
      age: int.tryParse(_controllers[2].text) ?? null,
      gender: _controllers[3].text,
      phone: _controllers[4].text,
    );

    if(!(_registerFormKey.currentState?.validate() ?? true)){
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await context.read<UserModel>().register(userInfo);

    if(result){
      BuildContext? hookContext;

      FocusScope.of(context).requestFocus(FocusNode());

      final popper = Timer(const Duration(
        milliseconds: 2000
      ), (){
        if(hookContext != null){
          Navigator.pop(hookContext!);
          //Navigator.pop(context);
        }
      });

      await showDialog(context: context, builder: (context){
        hookContext = context;
        return SimpleDialog(
          title: Center(
            child: Text (
              '注册成功！',
            ),
          ),
          titlePadding: const EdgeInsets.symmetric(
            vertical: 15.0,
          ),
        );
      }).then((value){
        popper.cancel();
        Navigator.pop(context);
      });
    }else{
      showToast('注册失败，可能存在重复的用户名',position: ToastPosition.bottom,);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
