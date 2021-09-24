// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
    eventType: json['eventType'] as String,
    data: json['data'],
  );
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'eventType': instance.eventType,
      'data': instance.data,
    };
