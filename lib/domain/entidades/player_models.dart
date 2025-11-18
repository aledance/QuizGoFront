import 'dart:convert';

class RegisterPlayerRequest {
  final String nickname;
  final int challengePin;

  RegisterPlayerRequest({required this.nickname, required this.challengePin});

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'challengePin': challengePin,
      };
}

class RegisterPlayerResponse {
  final String playerId;
  final String playerToken;

  RegisterPlayerResponse({required this.playerId, required this.playerToken});

  factory RegisterPlayerResponse.fromJson(Map<String, dynamic> json) => RegisterPlayerResponse(
        playerId: json['playerId'] as String,
        playerToken: json['playerToken'] as String,
      );

  @override
  String toString() => jsonEncode({'playerId': playerId, 'playerToken': playerToken});
}
