import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:phytopathy_prediction/models/phytopathy_encyclopedia_model.dart';
import 'package:phytopathy_prediction/route.dart';
import 'package:provider/provider.dart';

const List<String> _titles = [
  '植物病害检测',
  '植物病害百科',
  '实时天气播报',
  '植物病害咨询',
];
final _indexMapRoute = <int, String>{
  0: Routes.phytopathy_prediction,
  1: Routes.phytopathy_encyclopedia,
  2: Routes.weather_boradcast,
  3: Routes.chat_list,
};
const _introduceItemCount = 7;

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final banner = _Banner();

    final fTitle = _Title('功能');

    final function = _Function();

    final iTitle = _Title('植物疾病介绍');

    final introduce = _Introduce();

    return ListView(
      children: [
        banner,
        fTitle,
        function,
        iTitle,
        introduce,
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.0,
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 4.0,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.5,
      child: Swiper(
        autoplay: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Image.asset(
              'assets/pic/navigation/banner/$index.png',
              alignment: Alignment.topCenter,
              fit: BoxFit.fill,
            ),
            onTap: (){
              _handleTapIndex(context,index);
            },
          );
        },
        pagination: SwiperPagination(),
        itemCount: 4,
      ),
    );
  }

  void _handleTapIndex(BuildContext context,int index){
    Navigator.pushNamed(context, Routes.banner_detials,arguments: index);
  }
}

class _Function extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final img = Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/pic/navigation/function/$index.png',
            fit: BoxFit.contain,
          ),
        );

        final title = Text(
          _titles[index],
        );

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 1.5,
          margin: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 14.0,
          ),
          child: GestureDetector(
            onTap: () {
              _jumpToPage(context, index);
            },
            child: Container(
              margin: const EdgeInsets.all(14.0),
              //padding: const EdgeInsets.symmetric(),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: img),
                  const SizedBox(height: 5.0),
                  title,
                ],
              ),
            ),
          ),
        );
      },
      itemCount: _titles.length,
    );
  }

  void _jumpToPage(BuildContext context, int index) {
    Navigator.pushNamed(
      context,
      _indexMapRoute[index]!,
    );
  }
}

class _Introduce extends StatelessWidget {
  final _random = Random.secure();
  final Set<int> _set = Set();

  @override
  Widget build(BuildContext context) {
    final list = ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      itemBuilder: (context, index) {
        final peModel =
            Provider.of<PhytopathyEncyclopediaModel>(context, listen: false);
        final dataList = peModel.dataList;
        late int rIndex;

        while (true) {
          rIndex = _random.nextInt(dataList.length);
          if (!_set.contains(rIndex)) {
            _set.add(rIndex);
            break;
          }
        }

        late Widget child;

        if (index == _introduceItemCount - 1) {
          child = GestureDetector(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    size: 32.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 15.0),
                  const Text(
                    '查看更多',
                    //style: TextStyle(fontFamily: 'green'),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(Routes.phytopathy_encyclopedia);
            },
          );
        } else {
          final data = dataList[rIndex];

          final img = AspectRatio(
            aspectRatio: 1.0,
            child: Hero(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7.0),
                child: Image.asset(
                  'assets/pic/disease/$rIndex.JPG',
                  fit: BoxFit.cover,
                ),
              ),
              tag: data,
            ),
          );

          child = GestureDetector(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: img),
                const SizedBox(
                  height: 4.0,
                ),
                SizedBox(
                  child: Text(
                    data.titleZN,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(
                  context, Routes.phytopathy_encyclopedia_detail,
                  arguments: data);
            },
          );
        }

        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          margin: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 12.0,
          ),
          child: Container(
            width: 120.0,
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 7.0,
            ),
            child: child,
          ),
        );
      },
      itemCount: _introduceItemCount,
    );

    return SizedBox(
      height: 140.0,
      child: list,
    );
  }
}
