API layer added to the project to consume the common Reports API described by the user.

Files added:
- `lib/core/errors/api_exceptions.dart` — common API exceptions for 401/403/404 and general API errors.
- `lib/infrastructure/dtos/*.dart` — DTO classes: `SessionReportDto`, `PersonalResultDto`, `KahootResultSummaryDto` and helpers.
- `lib/infrastructure/datasources/reports_remote_datasource.dart` — HTTP client wrapper for the three endpoints.
- `lib/domain/repositories/reports_repository.dart` — repository interface.
- `lib/infrastructure/repositories/reports_repository_impl.dart` — repository implementation using the remote data source.
- `lib/application/usecases/*` — use cases: `GetSessionReport`, `GetPersonalResult`, `GetMyKahootResultsList`.
- `lib/presentation/services/reports_service.dart` — small factory/service to use from pages/controllers.

Quick usage example (from a page/controller):

```dart
final service = ReportsService.create(baseUrl: 'https://api.example.com');
final report = await service.getSessionReport.call('session-id', authToken: 'token');
```

Notes:
- The DTOs use manual `fromJson` constructors; no codegen required.
- `pubspec.yaml` already includes `http` dependency in this project. If missing, add `http`.
- Error conditions 401/403/404 are thrown as exceptions `UnauthorizedException`, `ForbiddenException`, `NotFoundException` respectively.

Next steps you may want:
- Integrate the service into your dependency injection/container.
- Map DTOs to domain entities if you'd like a strict domain layer separation.
- Add unit tests/mocks for the data source and repository.
