import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  const User({
    required this.username,
    required this.password,
    this.age,
    this.gender,
    this.phone,
    this.plant,
  });

  final String username;
  final String password;
  final int? age;
  final String? gender;
  final String? phone;
  final String? plant;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? username,
    String? password,
    int? age,
    String? gender,
    String? phone,
    String? plant,
  }) {
    return User(
      username: username ?? this.username,
      password: password ?? this.password,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      plant: plant ?? this.plant,
    );
  }

  @override
  String toString() {
    return 'username: $username\n'
        'password: $password';
  }
}
