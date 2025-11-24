import '../../domain/repositories/reports_repository.dart';
import '../../infrastructure/dtos/session_report_dto.dart';

class GetSessionReport {
  final ReportsRepository repository;

  GetSessionReport(this.repository);

  Future<SessionReportDto> call(String sessionId, {String? authToken}) {
    return repository.getSessionReport(sessionId, authToken: authToken);
  }
}
