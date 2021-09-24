
import 'package:flutter/material.dart';
import 'package:phytopathy_prediction/models/expert_consult_model.dart';
import 'package:provider/provider.dart';

class Consult extends StatelessWidget {

  static const routeName = 'consult';
  static Widget builder(BuildContext context) => Consult();

  final _expertConsultModel = ExpertConsultModel();

  @override
  Widget build(BuildContext context) {
    const padding = SizedBox(height: 25.0);

    final titleName = _Title('姓名');
    final name = _Name();
    final titleEmail = _Title('联系方式');
    final email = _Email();
    final titleContent = _Title('问题描述');
    final content = _Content();
    final submit = _Submit();

    final form = Form(
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 25.0,
          vertical: 8.0,
        ),
        children: [
          titleName,
          name,
          padding,
          titleEmail,
          email,
          padding,
          titleContent,
          content,
          padding,
          submit,
        ],
      ),
    );

    return Provider.value(
      value: _expertConsultModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text('植物疾病咨询'),
        ),
        body: form,
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        //horizontal: 5.0,
        vertical: 3.0,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  _TextField({
    required this.controller,
    this.limit = 10,
    this.maxLine = 1,
  });

  final TextEditingController controller;
  final int limit;
  final int maxLine;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          border: Border.all(
            width: 1.0,
            color: Colors.grey,
          )),
      child: TextFormField(
        style: TextStyle(
          fontSize: 20.0,
        ),
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        //cursorColor: Colors.,
        //maxLength: limit,
        // buildCounter: (
        //     BuildContext context, {
        //       required int currentLength,
        //       required int? maxLength,
        //       required bool isFocused,
        //     }) => SizedBox(
        //   height: 0.0,
        // ),
        maxLines: maxLine,
      ),
    );
  }
}

class _Name extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _TextField(
      controller: Provider.of<ExpertConsultModel>(context).nameController,
    );
  }
}

class _Email extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _TextField(
      controller: Provider.of<ExpertConsultModel>(context).emailController,
    );
  }
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _TextField(
      controller: Provider.of<ExpertConsultModel>(context).contentController,
      maxLine: 12,
    );
  }
}

class _Submit extends StatelessWidget {

  final _size = 20.0;

  @override
  Widget build(BuildContext context) {
    final child = MaterialButton(
      onPressed: () {},
      child: Container(
        height: 42.0,
        //alignment: Alignment.center,
        //width: 80.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('提交',style: TextStyle(color: Colors.white,fontSize: _size),),
            SizedBox(
              width: 16.0
            ),
            Icon(
              Icons.send,
              color: Colors.white,
              size: _size,
            )
          ],
        ),
      ),
      color: Theme.of(context).primaryColor,
    );
    
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0),child: child,) ;
  }
}
