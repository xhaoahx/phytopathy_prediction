import 'package:flutter/material.dart';
import 'package:phytopathy_prediction/objects/phytopathy_data.dart';

class PhytopathyEncyclopediaDetail extends StatelessWidget {

  static final routeName = 'phytopathy_encyclopedia_detail';
  static Widget builder(BuildContext context) => PhytopathyEncyclopediaDetail();

  @override
  Widget build(BuildContext context) {

  final data = ModalRoute.of(context)?.settings.arguments as PhytopathyData;

  return Scaffold(
      appBar: AppBar(
        title: Text(data.titleZN),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 2.0,
        ),
        children: [
          Container(
            height: 256.0,
            child: _CaptionContent(data),
          ),
          _DetailList(data),
        ],
      ),
    );
  }
}

class _CaptionContent extends StatelessWidget {
  _CaptionContent(this.data);

  final PhytopathyData data;

  @override
  Widget build(BuildContext context) {
    final titleZN = Text(
      data.titleZN,
      style: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w300,
      ),
      maxLines: 2,
      softWrap: true,
    );

    final titleEN = Text(
      data.titleEN,
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w200,
      ),
      maxLines: 1,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );

    final picture = Hero(
      tag: data,
      child: Image.asset(
        'assets/pic/disease/${data.index}.JPG',
        fit: BoxFit.cover,
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleZN,
              titleEN,
            ],
          ),
          flex: 5,
        ),
        Expanded(
          child: picture,
          flex: 4,
        )
      ],
    );
  }
}

class _DetailList extends StatefulWidget {
  _DetailList(this.data);

  final PhytopathyData data;

  @override
  _DetailListState createState() => _DetailListState();
}

class _DetailListState extends State<_DetailList> {
  late final List<bool> _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = List.generate(widget.data.details.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (index, isExpanded) {
        setState(() {
          _isExpanded[index] = !isExpanded;
        });
      },
      elevation: 0,
      dividerColor: Colors.transparent,
      children: List.generate(
        widget.data.details.length,
        (index) {
          final detail = widget.data.details[index];
          return ExpansionPanel(
            backgroundColor: Theme.of(context).canvasColor,
            headerBuilder: (context, isExpanded) {
              return ListTile(
                title: Text(
                  detail.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical: 2.0,
                ),
              );
            },
            body: Container(
              margin:
                  const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
              child: Text(
                '        ${detail.content}',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w200),
              ),
            ),
            isExpanded: _isExpanded[index],
          );
        },
      ),
    );
  }
}
