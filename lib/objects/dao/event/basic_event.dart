import 'package:json_annotation/json_annotation.dart';

part 'basic_event.g.dart';

@JsonSerializable()
class Event{
  Event({
    required this.eventType,
    this.data
  });

  factory Event.fromJson(Map<String,dynamic> json) => _$EventFromJson(json);

  final String eventType;
  final dynamic? data;

  Map<String,dynamic> toJson() => _$EventToJson(this);
}
