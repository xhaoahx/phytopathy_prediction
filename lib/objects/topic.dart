import 'package:json_annotation/json_annotation.dart';

part 'topic.g.dart';

@JsonSerializable()
class Topic {
  Topic({
    this.coverRate = 1.0,
    required this.index,
    required this.contentLength,
    required this.likes,
    required this.publisher,
    required this.publishDate,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  final int contentLength;
  final int index;
  final double coverRate;
  final int likes;
  final String publisher;
  final String publishDate;

  Map<String, dynamic> toJson() => _$TopicToJson(this);
}
