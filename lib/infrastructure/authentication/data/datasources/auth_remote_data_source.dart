import 'package:http/http.dart' as http;
import 'auth_api.dart';
import 'dart:convert';
import '../../../../domain/repositories/auth_repository.dart';


class AuthRemoteDataSourceImpl implements AuthRepository {
  final http.Client client; // Se inyecta el cliente HTTP

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<void> register(String email, String username, String password) async {
    final uri = Uri.parse(AuthApiEndpoints.register);

    // 1. Uso del endpoint centralizado
    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'username': username,
        'password': password,
      }),
    );

    // 2. Manejo de respuesta de infraestructura
    if (response.statusCode == 201) {
      // Éxito: retorna o procesa la respuesta (ej. token)
      return;
    } else {
      // Fallo: Lanza una excepción de infraestructura (ej. ServerException)
      throw Exception('Fallo al registrarse: ${response.statusCode}');
    }
  }

  @override
  Future<String> login(String email, String password) async {
    final uri = Uri.parse(AuthApiEndpoints.register);

    // 1. Uso del endpoint centralizado
    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    // 2. Manejo de respuesta de infraestructura
    if (response.statusCode == 201) {
      final responseBody = json.decode(response.body);
      // Extrae y retorna el accessToken
      return responseBody['accessToken'];
    } else {
      // Fallo: Lanza una excepción de infraestructura (ej. ServerException)
      throw Exception('Fallo al registrarse: ${response.statusCode}');
    }
  }
}