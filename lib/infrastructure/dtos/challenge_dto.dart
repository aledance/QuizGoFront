import '../../domain/entities/challenge.dart';

class ChallengeDto {
  final String? id;
  final String kahootId;
  final String? expirationDate;
  final int? challengePin;
  final String? shareLink;

  ChallengeDto({this.id, required this.kahootId, this.expirationDate, this.challengePin, this.shareLink});

  factory ChallengeDto.fromJson(Map<String, dynamic> json) => ChallengeDto(
        id: json['challengeId'] as String? ?? json['id'] as String?,
        kahootId: json['kahootId'] as String? ?? '',
        expirationDate: json['expirationDate'] as String?,
        challengePin: json['challengePin'] is int ? json['challengePin'] as int : (json['challengePin'] != null ? int.tryParse(json['challengePin'].toString()) : null),
        shareLink: json['shareLink'] as String? ?? json['shareLink'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'kahootId': kahootId,
        if (expirationDate != null) 'expirationDate': expirationDate,
      };

  Challenge toEntity() => Challenge(
        id: id,
        kahootId: kahootId,
        expirationDate: expirationDate != null ? DateTime.parse(expirationDate!) : null,
        challengePin: challengePin?.toString(),
        shareLink: shareLink,
      );

  factory ChallengeDto.fromEntity(Challenge c) => ChallengeDto(
        id: c.id,
        kahootId: c.kahootId,
        expirationDate: c.expirationDate?.toIso8601String(),
        challengePin: c.challengePin != null ? int.tryParse(c.challengePin!) : null,
        shareLink: c.shareLink,
      );
}
