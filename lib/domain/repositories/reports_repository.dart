import '../../infrastructure/dtos/session_report_dto.dart';
import '../../infrastructure/dtos/personal_result_dto.dart';
import '../../infrastructure/dtos/kahoot_result_summary_dto.dart';

abstract class ReportsRepository {
  Future<SessionReportDto> getSessionReport(String sessionId, {String? authToken});

  Future<PersonalResultDto> getPersonalKahootResult(String kahootId, {String? authToken});

  Future<PaginatedKahootResultsDto> getMyKahootResults({Map<String, dynamic>? queryParams, String? authToken});
}
