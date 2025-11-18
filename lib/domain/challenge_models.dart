import 'dart:convert';

class CreateChallengeRequest {
  final String kahootId;
  final DateTime? expirationDate;

  CreateChallengeRequest({required this.kahootId, this.expirationDate});

  Map<String, dynamic> toJson() => {
        'kahootId': kahootId,
        if (expirationDate != null) 'expirationDate': expirationDate!.toIso8601String(),
      };
}

class CreateChallengeResponse {
  final String challengeId;
  final int challengePin;
  final String shareLink;

  CreateChallengeResponse({required this.challengeId, required this.challengePin, required this.shareLink});

  factory CreateChallengeResponse.fromJson(Map<String, dynamic> json) => CreateChallengeResponse(
        challengeId: json['challengeId'] as String,
        challengePin: json['challengePin'] as int,
        shareLink: json['shareLink'] as String,
      );

  @override
  String toString() => jsonEncode({'challengeId': challengeId, 'challengePin': challengePin, 'shareLink': shareLink});
}
