import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/errors/api_exceptions.dart';
import '../dtos/session_report_dto.dart';
import '../dtos/personal_result_dto.dart';
import '../dtos/kahoot_result_summary_dto.dart';

class ReportsRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ReportsRemoteDataSource({
    required this.client,
    required this.baseUrl,
    this.defaultHeaders = const {'Content-Type': 'application/json'},
  });

  Uri _buildUri(String path, [Map<String, dynamic>? queryParams]) {
    final uri = Uri.parse(baseUrl + path);
    if (queryParams == null) return uri;
    return uri.replace(queryParameters: queryParams.map((k, v) => MapEntry(k, v.toString())));
  }

  void _handleErrors(http.Response response) {
    if (response.statusCode == 401) throw UnauthorizedException();
    if (response.statusCode == 403) throw ForbiddenException();
    if (response.statusCode == 404) throw NotFoundException();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException('API error', statusCode: response.statusCode);
    }
  }

  Future<SessionReportDto> getSessionReport(String id, {String? authToken}) async {
    final uri = _buildUri('/reports/sessions/$id');
    final headers = Map<String, String>.from(defaultHeaders);
    if (authToken != null) headers['Authorization'] = 'Bearer $authToken';

    final resp = await client.get(uri, headers: headers);
    _handleErrors(resp);

    final jsonBody = jsonDecode(resp.body) as Map<String, dynamic>;
    return SessionReportDto.fromJson(jsonBody);
  }

  Future<PersonalResultDto> getMyKahootResult(String kahootId, {String? authToken}) async {
    final uri = _buildUri('/reports/kahoots/$kahootId/my-results');
    final headers = Map<String, String>.from(defaultHeaders);
    if (authToken != null) headers['Authorization'] = 'Bearer $authToken';

    final resp = await client.get(uri, headers: headers);
    _handleErrors(resp);

    final jsonBody = jsonDecode(resp.body) as Map<String, dynamic>;
    return PersonalResultDto.fromJson(jsonBody);
  }

  Future<PaginatedKahootResultsDto> getMyKahootResults({Map<String, dynamic>? queryParams, String? authToken}) async {
    final uri = _buildUri('/reports/kahoots/my-results', queryParams);
    final headers = Map<String, String>.from(defaultHeaders);
    if (authToken != null) headers['Authorization'] = 'Bearer $authToken';

    final resp = await client.get(uri, headers: headers);
    _handleErrors(resp);

    final jsonBody = jsonDecode(resp.body) as Map<String, dynamic>;
    return PaginatedKahootResultsDto.fromJson(jsonBody);
  }
}
