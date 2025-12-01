class RankingItemDto {
  final String nickname;
  final int totalScore;
  final int timeAvgMs;
  final int rank;

  RankingItemDto({required this.nickname, required this.totalScore, required this.timeAvgMs, required this.rank});

  factory RankingItemDto.fromJson(Map<String, dynamic> json) => RankingItemDto(
        nickname: json['nickname'] as String? ?? '',
        totalScore: json['totalScore'] as int? ?? 0,
        timeAvgMs: json['timeAvgMs'] as int? ?? 0,
        rank: json['rank'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'totalScore': totalScore,
        'timeAvgMs': timeAvgMs,
        'rank': rank,
      };
}
