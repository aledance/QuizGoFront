class KahootResultSummaryDto {
  final String kahootId;
  final String title;
  final DateTime completionDate;
  final int finalScore;
  final int rankingPosition;

  KahootResultSummaryDto({
    required this.kahootId,
    required this.title,
    required this.completionDate,
    required this.finalScore,
    required this.rankingPosition,
  });

  factory KahootResultSummaryDto.fromJson(Map<String, dynamic> json) {
    return KahootResultSummaryDto(
      kahootId: json['kahootId'] as String,
      title: json['title'] as String,
      completionDate: DateTime.parse(json['completionDate'] as String),
      finalScore: json['finalScore'] as int,
      rankingPosition: json['rankingPosition'] as int,
    );
  }
}

class PaginatedKahootResultsDto {
  final List<KahootResultSummaryDto> results;
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final int limit;

  PaginatedKahootResultsDto({
    required this.results,
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.limit,
  });

  factory PaginatedKahootResultsDto.fromJson(Map<String, dynamic> json) {
    return PaginatedKahootResultsDto(
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => KahootResultSummaryDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalItems: json['meta'] != null ? (json['meta']['totalItems'] as int) : 0,
      currentPage: json['meta'] != null ? (json['meta']['currentPage'] as int) : 1,
      totalPages: json['meta'] != null ? (json['meta']['totalPages'] as int) : 1,
      limit: json['meta'] != null ? (json['meta']['limit'] as int) : (json['results'] as List<dynamic>?)?.length ?? 0,
    );
  }
}
