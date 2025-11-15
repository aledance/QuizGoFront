// lib/domain/user/models/user.dart

/// Representa el modelo de entidad de un Usuario en la capa de dominio.
///
/// Este objeto contiene los datos fundamentales de un usuario, limpio de
/// cualquier detalle de implementación de la UI o de la capa de datos.
class User {
  final String username;
  final String email;
  // Puedes añadir más campos que sean relevantes para el dominio, como:
  // final String? avatarUrl;
  // final int score;

  User({
    required this.username,
    required this.email,
  });
}
