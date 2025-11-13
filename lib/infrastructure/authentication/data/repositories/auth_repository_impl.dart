// lib/features/authentication/data/repositories/auth_repository_impl.dart

// Importa el Puerto (interfaz) desde la capa core/
import '../../../../core/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> register(String email, String username, String password) async {
    try {
      // Llama a la infraestructura (DataSource que usa el Endpoint)
      await remoteDataSource.registerUser(email, username, password);
    } catch (e) {
      // Traduce la excepción de infraestructura a una excepción de dominio
      throw DomainRegistrationError('Error de registro. Intente más tarde.');
    }
  }
}