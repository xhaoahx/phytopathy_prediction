// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    srcUsername: json['srcUsername'] as String,
    dstUsername: json['dstUsername'] as String,
    roomHash: json['roomHash'] as int,
    time: json['time'] == null ? null : DateTime.parse(json['time'] as String),
    type: _$enumDecodeNullable(_$MessageTypeEnumMap, json['type']),
    id: json['id'] as int?,
    content: json['content'],
    isLauncher: json['isLauncher'] as bool,
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'srcUsername': instance.srcUsername,
      'dstUsername': instance.dstUsername,
      'roomHash': instance.roomHash,
      'time': instance.time?.toIso8601String(),
      'content': instance.content,
      'type': _$MessageTypeEnumMap[instance.type],
      'id': instance.id,
      'isLauncher': instance.isLauncher,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$MessageTypeEnumMap = {
  MessageType.string: 'string',
  MessageType.file: 'file',
};
