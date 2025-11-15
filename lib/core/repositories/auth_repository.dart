// lib/core/repositories/auth_repository.dart

// Este es el "Puerto" en la terminología de Arquitectura Limpia/Hexagonal.
// Define el contrato que cualquier implementación de repositorio de autenticación debe seguir.

abstract class AuthRepository {
  /// Registra un nuevo usuario con su email, nombre de usuario y contraseña.
  ///
  /// Lanza un [DomainRegistrationError] si el proceso de registro falla
  /// por cualquier motivo en la capa de datos o infraestructura.
  Future<void> register(String email, String username, String password);
  Future<String> login(String email, String password); //falta implementar el usuario

// Aquí podrías añadir otros métodos relacionados con la autenticación en el futuro,
// como por ejemplo:
//
// Future<void> logout();
}

/// Una excepción personalizada para errores de dominio relacionados con el registro.
/// Esto permite que la capa de UI/Presentación reaccione a errores de registro
/// sin necesidad de conocer los detalles de implementación (como errores de red o de servidor).
class DomainRegistrationError implements Exception {
  final String message;
  DomainRegistrationError(this.message);

  @override
  String toString() => message;
}

