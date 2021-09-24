import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class PhytopathyDetail {
  PhytopathyDetail(this.title, this.content);

  final String title;
  final String content;

  factory PhytopathyDetail.fromJson(Map<dynamic, dynamic> json) {
    return PhytopathyDetail(
        json['subtitle'] as String, json['content'] as String);
  }

  @override
  String toString() {
    return '<$title:'
        '$content>';
  }
}

class PhytopathyData {
  PhytopathyData(this.index, this.titleZN, this.titleEN, this.details);

  final int index;
  final String titleZN;
  final String titleEN;
  final List<PhytopathyDetail> details;

  static const String _jsonPath = 'assets/json/phytopathy_data.json';

  factory PhytopathyData.fromJson(int index, Map<dynamic, dynamic> json) {

    final titleZN = json['title_zn'];
    final titleEN = json['title_en'];
    final detailsList = json['details'] as List;
    final details = detailsList.map((map) {
      return PhytopathyDetail.fromJson(map);
    }).toList();

    return PhytopathyData(index, titleZN, titleEN, details);
  }

  static Future<List<PhytopathyData>> loadAllFromAssets() async {
    final jsonString = await rootBundle.loadString(_jsonPath);
    final json = jsonDecode(jsonString) as List;

    return List.generate(
      json.length,
      (index) => PhytopathyData.fromJson(index, json[index]),
    );
  }

  @override
  String toString() {
    return '\t$titleEN\n'
        '\t$titleZN'
        '$details';
  }
}

class ClassificationData {
  const ClassificationData(this.begin, this.length, this.mainIndex);

  final int begin;
  final int length;
  final int mainIndex;
}

const List<ClassificationData> classifications = [
  const ClassificationData(0, 4, 3),
  const ClassificationData(4, 1, 4),
  const ClassificationData(5, 2, 6),
  const ClassificationData(7, 4, 10),
  const ClassificationData(11, 4, 14),
  const ClassificationData(15, 1, 15),
  const ClassificationData(16, 2, 17),
  const ClassificationData(18, 2, 19),
  const ClassificationData(20, 3, 22),
  const ClassificationData(23, 1, 23),
  const ClassificationData(24, 1, 24),
  const ClassificationData(25, 1, 25),
  const ClassificationData(26, 2, 27),
  const ClassificationData(28, 10, 37),
];

bool isClassification(int index){
  for(int i = 0;i < classifications.length;i++){
    //print('isClassification');
    if(index == classifications[i].mainIndex){
      return true;
    }
  }
  return false;
}

int indexOf(int i,int j){
  int result = 0;
  for(int m = 0;m < i;m ++){
    print('indexOF');
    result += classifications[m].length;
  }

  assert(result + j < 38);
  return result + j;
}