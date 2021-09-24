import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:like_button/like_button.dart';
import 'package:phytopathy_prediction/models/discovery_model.dart';
import 'package:phytopathy_prediction/route.dart';
import 'package:provider/provider.dart';

class Discovery extends StatefulWidget {
  @override
  _DiscoveryState createState() => _DiscoveryState();
}

class _DiscoveryState extends State<Discovery> {
  @override
  void initState() {
    context.read<DiscoveryModel>().initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<DiscoveryModel>().initialized) {
      return _DiscoveryContent();
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

class _DiscoveryContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = context.read<DiscoveryModel>();

    return RefreshIndicator(
      child: Selector<DiscoveryModel, Object>(
        selector: (BuildContext context, DiscoveryModel model) =>
            model.topicsChanged,
        builder: (BuildContext context, Object value, Widget? child) {
          final topics = context.read<DiscoveryModel>().topics;
          final grid = StaggeredGridView.countBuilder(
            crossAxisCount: 10,
            staggeredTileBuilder: (index) {
              //print('index: $index => ${topics[index].coverRate * 5 + 3}');
              return StaggeredTile.count(
                5,
                topics[index].coverRate * 4 + 3.0,
              );
            },
            itemBuilder: (context, index) {
              return _TopicItem(
                topics[index],
                index,
              );
            },
            itemCount: topics.length,
          );

          return RefreshIndicator(child: grid, onRefresh: model.refresh);
        },
        shouldRebuild: (Object previous, Object next) => previous != next,
      ),
      onRefresh: model.loadMore,
    );
  }
}

class _TopicItem extends StatelessWidget {
  _TopicItem(
    this.topic,
      this.index,
  );

  final int index;
  final TopicWrapper topic;

  @override
  Widget build(BuildContext context) {
    final coverImg = ClipRRect(
      child: Image.asset(
        'assets/pic/discovery/${topic.index}.png',
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(15.0),
    );

    final publisher = Text(
      topic.publisher,
      style: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 20.0,
      ),
    );

    final publisherDate = Text(
      topic.publishDate,
      style: TextStyle(
          fontWeight: FontWeight.w200,
          fontSize: 12.0,
          color: Colors.grey.withOpacity(0.7)),
    );

    final double size = 24.0;

    final themeData = Theme.of(context);
    final likeButton = LikeButton(
      size: size,
      likeCount: topic.currentLikes,
      mainAxisAlignment: MainAxisAlignment.start,
      bubblesColor: BubblesColor(
        dotPrimaryColor: themeData.primaryColorLight,
        dotSecondaryColor: themeData.primaryColor,
      ),
      circleColor: CircleColor(
        start: themeData.primaryColor,
        end: themeData.primaryColorLight,
      ),
      isLiked: topic.liked,
      likeBuilder: (bool isLiked) {
        return Icon(
          Icons.favorite,
          color: isLiked ? themeData.accentColor : Colors.grey,
          size: size,
        );
      },
      countBuilder: (int? count, bool isLiked, String text) {
        final ColorSwatch<int> color = isLiked ? Colors.green : Colors.grey;
        return Selector<DiscoveryModel, int>(
          builder: (context, value, child) {
            Widget result;
            if (count == 0) {
              result = Text(
                'love',
                style: TextStyle(color: color),
              );
            } else
              result = Text(
                count! >= 1000
                    ? (count / 1000.0).toStringAsFixed(1) + 'k'
                    : text,
                style: TextStyle(color: color),
              );
            return result;
          },
          selector: (context, model) => model.topics[index].currentLikes,
          shouldRebuild: (previous, next) => previous != next,
        );
      },
      likeCountAnimationType: topic.currentLikes < 1000
          ? LikeCountAnimationType.part
          : LikeCountAnimationType.none,
      likeCountPadding: const EdgeInsets.only(left: 15.0),
      onTap: (bool liked) async {
        if (liked) {
          context.read<DiscoveryModel>().unlikeTopic(index);
        } else {
          context.read<DiscoveryModel>().likeTopic(index);
        }
        return !liked;
      },
    );

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        publisher,
        publisherDate,
        const SizedBox(
          height: 6.0,
        ),
        likeButton,
      ],
    );

    final item = Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
      ),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.07),
            blurRadius: 4.0,
            spreadRadius: 3.0,
            offset: Offset(0.0, 1.0),
          )
        ],
        borderRadius: BorderRadius.circular(16.0),
        gradient: topic.likes > 200
            ? LinearGradient(
                colors: [
                  Theme.of(context).accentColor.withOpacity(0.2),
                  Colors.white,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : null,
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: coverImg,
            ),
          ),
          Padding(
            child: details,
            padding: const EdgeInsets.symmetric(
              vertical: 6.0,
              horizontal: 12.0,
            ),
          )
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.topic_details,
          arguments: topic,
        );
      },
      child: item,
    );
  }
}
