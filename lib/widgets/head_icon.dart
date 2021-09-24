import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HeadIcon extends StatelessWidget {
  HeadIcon({
    required this.username,
    required this.size,
  });

  final String username;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(7.0),
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 1.0,
        )
      ),
      child: Text(
        username[0],
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: size * 0.75,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

