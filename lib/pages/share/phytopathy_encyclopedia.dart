import 'package:flutter/material.dart';
import 'package:phytopathy_prediction/models/phytopathy_encyclopedia_model.dart';
import 'package:phytopathy_prediction/objects/phytopathy_data.dart';
import 'package:phytopathy_prediction/route.dart';
import 'package:provider/provider.dart';

class PhytopathyEncyclopedia extends StatelessWidget {

  static const routeName = 'phytopathy_encyclopedia';
  static Widget builder(context) => PhytopathyEncyclopedia();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('植物疾病百科'),
      ),
      body: _PhytopathyEPBody(),
    );
  }
}

class _PhytopathyEPBody extends StatefulWidget {
  @override
  _PhytopathyEPBodyState createState() => _PhytopathyEPBodyState();
}

class _PhytopathyEPBodyState extends State<_PhytopathyEPBody> {
  late final PhytopathyEncyclopediaModel _model;

  @override
  void initState() {
    super.initState();
    _model = Provider.of<PhytopathyEncyclopediaModel>(context, listen: false);
    _model.initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<PhytopathyEncyclopediaModel>().isLoaded) {
      assert(_model.isLoaded);
      return _PhytopathyEPContent(_model.dataList);
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

class _PhytopathyEPContent extends StatefulWidget {
  _PhytopathyEPContent(this.dataList);

  final List<PhytopathyData> dataList;

  @override
  _PhytopathyEPContentState createState() => _PhytopathyEPContentState();
}

class _PhytopathyEPContentState extends State<_PhytopathyEPContent> {
  int _selected = 0;
  final _buttonList = List.generate(classifications.length, (index) => false);
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    _buttonList[0] = true;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataList = widget.dataList;

    final chooser = GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 3.0,
      ),
      itemBuilder: (context, index) {
        final themeData = Theme.of(context);
        final button = GestureDetector(
          onTap: () {
            _jumpToPage(index);
          },
          child: Container(
            margin: const EdgeInsets.all(2.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: _selected == index
                    ? themeData.primaryColor
                    : themeData.canvasColor,
                borderRadius: BorderRadius.circular(3.0),
                border: Border.all(
                  color: themeData.primaryColor,
                )),
            child: Text(
              dataList[classifications[index].mainIndex].titleZN,
              style: TextStyle(
                  color: _selected == index ? Colors.white : Colors.black),
            ),
          ),
        );

        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 28.0),
          child: button,
        );
      },
      itemCount: classifications.length,
    );

    final pages = PageView.builder(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, j) {
            final dataIndex = indexOf(i, j);
            final PhytopathyData data = dataList[dataIndex];

            final photo = AspectRatio(
              aspectRatio: 1.0,
              child: Hero(
                tag: data,
                child: Image.asset(
                  'assets/pic/disease/${data.index}.JPG',
                  fit: BoxFit.cover,
                ),
              ),
            );

            final content = Container(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      //padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        border: Border.all(
                            width: 2.0, color: Theme.of(context).primaryColor),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: photo
                      ),
                    ),
                    flex: 5,
                  ),
                  Expanded(
                    child: Text(
                      data.titleZN,
                      maxLines: 2,
                      softWrap: true,
                    ),
                    flex: 2,
                  ),
                ],
              ),
            );

            return GestureDetector(
              child: content,
              onTap: () {
                Navigator.of(context).pushNamed(Routes.phytopathy_encyclopedia_detail,arguments: data);
              },
            );
          },
          itemCount: classifications[i].length,
        );
      },
      itemCount: classifications.length,
    );

    final titleStyle = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w200,
    );

    final chooserTitle = Text(
      '植物分类',
      style: titleStyle,
    );

    final pageTitle = Text(
      '疾病分类',
      style: titleStyle,
    );

    //print('gird and page');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          chooserTitle,
          chooser,
          pageTitle,
          Expanded(
            child: pages,
          ),
        ],
      ),
    );
  }

  void _jumpToPage(int index) {
    setState(() {
      _selected = index;
      _pageController.jumpToPage(index);
    });
  }
}
