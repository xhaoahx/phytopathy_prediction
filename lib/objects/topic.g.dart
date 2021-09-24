// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topic _$TopicFromJson(Map<String, dynamic> json) {
  return Topic(
    coverRate: (json['coverRate'] as num).toDouble(),
    index: json['index'] as int,
    contentLength: json['contentLength'] as int,
    likes: json['likes'] as int,
    publisher: json['publisher'] as String,
    publishDate: json['publishDate'] as String,
  );
}

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'contentLength': instance.contentLength,
      'index': instance.index,
      'coverRate': instance.coverRate,
      'likes': instance.likes,
      'publisher': instance.publisher,
      'publishDate': instance.publishDate,
    };
