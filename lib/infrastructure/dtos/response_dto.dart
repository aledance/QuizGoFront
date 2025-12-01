class ResponseDto {
  final int slideIndex;
  final int answerIndex;
  final int timeElapsedMs;

  ResponseDto({required this.slideIndex, required this.answerIndex, required this.timeElapsedMs});

  factory ResponseDto.fromJson(Map<String, dynamic> json) => ResponseDto(
        slideIndex: json['slideIndex'] as int? ?? 0,
        answerIndex: json['answerIndex'] as int? ?? 0,
        timeElapsedMs: json['timeElapsedMs'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'slideIndex': slideIndex,
        'answerIndex': answerIndex,
        'timeElapsedMs': timeElapsedMs,
      };
}
