class AuthApiEndpoints {
  // URL base de ejemplo
  static const String baseUrl = 'https://api.quizgo.com/v1';

  // Endpoints específicos de la épica de Autenticación
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String refresh = '$baseUrl/auth/token/refresh';

// Puedes agregar la lógica para cambiar el baseUrl aquí si es necesario
}