import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

enum MessageType {
  string,
  file,
}

@JsonSerializable()
class Message {
  Message({
    required this.srcUsername,
    required this.dstUsername,
    required this.roomHash,
    this.time,
    this.type,
    this.id,
    this.content,
    this.isLauncher = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  final String srcUsername;
  final String dstUsername;
  final int roomHash;

  @JsonKey(nullable: true)
  final DateTime? time;
  @JsonKey(nullable: true)
  final dynamic? content;
  @JsonKey(nullable: true)
  final MessageType? type;
  @JsonKey(nullable: true)
  final int? id;

  bool isLauncher;

  @override
  String toString() {
    return '$srcUsername: $content => $dstUsername';
  }
}
