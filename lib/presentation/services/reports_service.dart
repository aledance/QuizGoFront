import 'package:http/http.dart' as http;

import '../../application/usecases/get_my_results_list.dart';
import '../../application/usecases/get_personal_result.dart';
import '../../application/usecases/get_session_report.dart';
import '../../infrastructure/datasources/reports_remote_datasource.dart';
import '../../infrastructure/repositories/reports_repository_impl.dart';

/// Small convenience service to be used by pages/controllers.
class ReportsService {
  final GetSessionReport getSessionReport;
  final GetPersonalResult getPersonalResult;
  final GetMyKahootResultsList getMyResultsList;

  ReportsService._({
    required this.getSessionReport,
    required this.getPersonalResult,
    required this.getMyResultsList,
  });

  /// Creates a service with a real HTTP client. Provide `baseUrl` of the API (e.g. 'https://api.example.com').
  factory ReportsService.create({required String baseUrl, String? authToken}) {
    final client = http.Client();
    final remote = ReportsRemoteDataSource(client: client, baseUrl: baseUrl);
    final repo = ReportsRepositoryImpl(remote: remote);
    return ReportsService._(
      getSessionReport: GetSessionReport(repo),
      getPersonalResult: GetPersonalResult(repo),
      getMyResultsList: GetMyKahootResultsList(repo),
    );
  }
}
