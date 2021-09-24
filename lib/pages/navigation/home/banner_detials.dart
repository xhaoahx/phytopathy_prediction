import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BannerDetails extends StatefulWidget {
  static const routeName = 'banner_details';
  static Widget builder(BuildContext context) => BannerDetails();

  @override
  _BannerDetailsState createState() => _BannerDetailsState();
}

class _BannerDetailsState extends State<BannerDetails> {
  bool _isLoading = true;
  late final List<dynamic> _dataList;

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/json/banner_details.json').then((value) {
      _dataList = jsonDecode(value);

      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context)!.settings.arguments as int;

    final child = _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            children: List.generate(_dataList[index], (i) {
              return Image.asset(
                'assets/pic/navigation/banner_detail/${index}_$i.png',
                fit: BoxFit.fitWidth,
              );
            }),
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '详情',
        ),
      ),
      body: child,
    );
  }
}
