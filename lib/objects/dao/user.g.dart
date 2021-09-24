// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    username: json['username'] as String,
    isExpert: json['isExpert'] as bool,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'isExpert': instance.isExpert,
      'username': instance.username,
    };
