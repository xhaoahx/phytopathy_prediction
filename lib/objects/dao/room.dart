

enum Agreement{
  agree,
  refuse,
  busy,
  not_exists,
}

class RoomInfo {
  RoomInfo({
    required this.host,
    required this.guest,
    required this.hash,
  });

  factory RoomInfo.fromJson(Map<String, dynamic> json) {
    return RoomInfo(
      host: json['host'] as String,
      guest: json['guest'] as String,
      hash: json['hash'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'host': host,
        'guest': guest,
        'hash': hash,
      };

  final String host;
  final String guest;
  final int hash;
}

class InviteResponseInfo {
  InviteResponseInfo({
    required this.agreement,
    required this.hash,
  });

  factory InviteResponseInfo.fromJson(Map<String, dynamic> json) {
    return InviteResponseInfo(
        agreement: json['agreement'] as int, hash: json['hash'] as int);
  }

  Map<String, dynamic> toJson() => {
        'agreement': agreement,
        'hash': hash,
      };

  final int agreement;
  final int hash;
}
