import 'package:flutter/material.dart';
import 'package:phytopathy_prediction/models/discovery_model.dart';

class TopicDetails extends StatelessWidget {
  static const routeName = 'topic_details';
  static Widget builder(BuildContext context) => TopicDetails();

  @override
  Widget build(BuildContext context) {
    final topic = ModalRoute.of(context)?.settings.arguments as TopicWrapper;

    return Scaffold(
        appBar: AppBar(
          title: Text('话题详情'),
        ),
        body: SizedBox(
          //alignment: Alignment.topCenter,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              vertical: 6.0,
              horizontal: 12.0,
            ),
            children: List.generate(
              topic.contentLength,
              (i) => Image.asset('assets/pic/discovery/${topic.index}_$i.png'),
            ),
          ),
        ));
  }
}
