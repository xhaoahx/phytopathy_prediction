import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User{

  User({
    required this.username,
    required this.isExpert,
});

  factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);
  Map<String,dynamic> toJson() => _$UserToJson(this);

  final bool isExpert;
  final String username;

  @override
  String toString() {
    return username;
  }
}