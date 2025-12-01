class Challenge {
  final String? id;
  final String kahootId;
  final DateTime? expirationDate;
  final String? challengePin;
  final String? shareLink;

  Challenge({this.id, required this.kahootId, this.expirationDate, this.challengePin, this.shareLink});
}
