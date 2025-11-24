import '../../domain/repositories/reports_repository.dart';
import '../datasources/reports_remote_datasource.dart';
import '../dtos/session_report_dto.dart';
import '../dtos/personal_result_dto.dart';
import '../dtos/kahoot_result_summary_dto.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsRemoteDataSource remote;

  ReportsRepositoryImpl({required this.remote});

  @override
  Future<SessionReportDto> getSessionReport(String sessionId, {String? authToken}) {
    return remote.getSessionReport(sessionId, authToken: authToken);
  }

  @override
  Future<PersonalResultDto> getPersonalKahootResult(String kahootId, {String? authToken}) {
    return remote.getMyKahootResult(kahootId, authToken: authToken);
  }

  @override
  Future<PaginatedKahootResultsDto> getMyKahootResults({Map<String, dynamic>? queryParams, String? authToken}) {
    return remote.getMyKahootResults(queryParams: queryParams, authToken: authToken);
  }
}
