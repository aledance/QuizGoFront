class PlayerDto {
  final String playerId;
  final String playerToken;
  final String? nickname;

  PlayerDto({required this.playerId, required this.playerToken, this.nickname});

  factory PlayerDto.fromJson(Map<String, dynamic> json) => PlayerDto(
        playerId: json['playerId'] as String? ?? json['id'] as String? ?? '',
        playerToken: json['playerToken'] as String? ?? json['token'] as String? ?? '',
        nickname: json['nickname'] as String? ?? json['nickname'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'playerId': playerId,
        'playerToken': playerToken,
        if (nickname != null) 'nickname': nickname,
      };
}
