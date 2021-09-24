// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    username: json['username'] as String,
    password: json['password'] as String,
    age: json['age'] as int?,
    gender: json['gender'] as String?,
    phone: json['phone'] as String?,
    plant: json['plant'] as String?,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'age': instance.age,
      'gender': instance.gender,
      'phone': instance.phone,
      'plant': instance.plant,
    };
