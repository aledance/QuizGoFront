import '../../domain/repositories/reports_repository.dart';
import '../../infrastructure/dtos/personal_result_dto.dart';

class GetPersonalResult {
  final ReportsRepository repository;

  GetPersonalResult(this.repository);

  Future<PersonalResultDto> call(String kahootId, {String? authToken}) {
    return repository.getPersonalKahootResult(kahootId, authToken: authToken);
  }
}
