import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:phytopathy_prediction/common/error_handler.dart';
import 'package:phytopathy_prediction/objects/topic.dart';
import 'dart:math';

export 'package:phytopathy_prediction/objects/topic.dart';

const _dataPath = 'assets/json/discovery_data.json';

final _random = Random.secure();

class TopicWrapper extends Topic {
  late bool liked;
  late int currentLikes;

  factory TopicWrapper.fromJson(Map<String, dynamic> json) {
    final topic = Topic.fromJson(json);
    return TopicWrapper(
      contentLength: topic.contentLength,
      index: topic.index,
      coverRate: topic.coverRate,
      likes: topic.likes,
      publisher: topic.publisher,
      publishDate: topic.publishDate,
    );
  }

  TopicWrapper({
    double coverRate = 1.0,
    required int contentLength,
    required int likes,
    required int index,
    required String publisher,
    required String publishDate,
  })   : liked = false,
        currentLikes = likes,
        super(
          contentLength: contentLength,
          index: index,
          coverRate: coverRate,
          likes: likes,
          publisher: publisher,
          publishDate: publishDate,
        );
}

class DiscoveryModel with ChangeNotifier {
  bool get initialized => _initialized;
  bool _initialized = false;

  Object get topicsChanged => _topicsChanged;
  Object _topicsChanged = Object();

  late final List _jsonData;

  List<TopicWrapper> get topics => _topics;
  final List<TopicWrapper> _topics = [];


  void _randomData() {
    _topics.addAll(
      List<TopicWrapper>.generate(
        20,
        (index) {
          return TopicWrapper.fromJson(
            _jsonData[_random.nextInt(_jsonData.length)],
          );
        },
      ),
    );
    _topicsChanged = new Object();
  }

  void initialize() async {
    if(_initialized) return;

    final dataString = await rootBundle.loadString(_dataPath);
    try {
      _jsonData = jsonDecode(dataString) as List;

      _topics.clear();
      _randomData();

      _initialized = true;
      notifyListeners();
    } catch (e, s) {
      errorPrintHandler(e, s);
      //_topics = List.empty();
    }
  }

  void likeTopic(int index) {
    _topics[index].currentLikes += 1;
    _topics[index].liked = true;
  }

  void unlikeTopic(int index) {
    _topics[index].currentLikes -= 1;
    _topics[index].liked = false;
  }

  Future<void> refresh() async {
    print('refresh');
    await Future.delayed(const Duration(milliseconds: 700));
    _topics.clear();
    _randomData();
    notifyListeners();
  }

  Future<void> loadMore() async {}
}
