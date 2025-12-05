import '../../domain/repositories/reports_repository.dart';
import '../../infrastructure/dtos/kahoot_result_summary_dto.dart';

class GetMyKahootResultsList {
  final ReportsRepository repository;

  GetMyKahootResultsList(this.repository);

  Future<PaginatedKahootResultsDto> call({Map<String, dynamic>? queryParams, String? authToken}) {
    return repository.getMyKahootResults(queryParams: queryParams, authToken: authToken);
  }
}
