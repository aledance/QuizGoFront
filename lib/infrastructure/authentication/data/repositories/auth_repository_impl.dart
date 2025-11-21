// lib/features/authentication/data/repositories/auth_repository_impl.dart

// Importa el Puerto (interfaz) desde la capa core/
import '../../../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRepository remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> register(String email, String username, String password) async {
    try {
      // Llama a la infraestructura (DataSource que usa el Endpoint)
      await remoteDataSource.register(email, username, password);
    } catch (e) {
      // Traduce la excepción de infraestructura a una excepción de dominio
      throw DomainRegistrationError('Error de registro. Intente más tarde.');
    }
  }

  @override
  Future<String> login(String emailUsername, String password) async {
    try {
      final String token = await remoteDataSource.login(emailUsername, password);
      // 2. Retorna el token a la capa que llamó al repositorio (UseCase)
      return token;
    } catch (e) {
      // Traduce la excepción de infraestructura a una excepción de dominio
      throw DomainRegistrationError('Error de registro. Intente más tarde.');
    }
  }
}