import 'dart:convert';

class RankingEntry {
  final String nickname;
  final int totalScore;
  final double timeAvgMs;
  final int rank;

  RankingEntry({required this.nickname, required this.totalScore, required this.timeAvgMs, required this.rank});

  factory RankingEntry.fromJson(Map<String, dynamic> json) => RankingEntry(
        nickname: json['nickname'] as String,
        totalScore: (json['totalScore'] as num).toInt(),
        timeAvgMs: (json['timeAvgMs'] as num).toDouble(),
        rank: (json['rank'] as num).toInt(),
      );

  @override
  String toString() => jsonEncode({'nickname': nickname, 'totalScore': totalScore, 'timeAvgMs': timeAvgMs, 'rank': rank});
}
