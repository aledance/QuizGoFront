import 'package:flutter/material.dart';
// Asegúrate de importar tus archivos necesarios
import 'package:flutter_application_1/core/repositories/auth_repository.dart';
import 'package:flutter_application_1/infrastructure/authentication/data/repositories/auth_repository_impl.dart';
import 'package:flutter_application_1/infrastructure/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:http/http.dart' as http;

import './register.dart';
import '/core/utils/colors.dart';

// 1. Convertido a StatefulWidget
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 2. Controladores para los campos de texto
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  // Dependencia del repositorio (esto se debe inyectar con un gestor de dependencias como GetIt o Provider en un proyecto real)
  late final AuthRepository authRepository;

  @override
  void initState() {
    super.initState();
    // Inicialización simple para este ejemplo
    authRepository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(client: http.Client()),
    );
  }

  // 3. Método para manejar la lógica de login
  void _handleLogin() async {
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text.trim();

    // Validación simple
    if (identifier.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    try {
      // Llamada al método del repositorio
      final token = await authRepository.login(identifier, password);

      // Éxito: Navega a la pantalla principal o muestra un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inicio de sesión exitoso! Token: ${token.substring(0, 10)}...')),
      );

      // Ejemplo de navegación a una pantalla de inicio (reemplaza 'HomePage' por tu pantalla principal)
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    } catch (e) {
      // Otros errores (ej. de red)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error inesperado: $e')),
      );
    }
  }

  @override
  void dispose() {
    // Limpia los controladores cuando el widget se destruye
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryPurple, darkPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'QuizGo!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Bienvenido de vuelta',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 40),
                // Se pasa el estado al método de construcción del formulario
                _buildLoginForm(),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text(
                    '¿No tienes cuenta? Regístrate',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        _AuthInputField(
          // Asigna el controlador
          controller: _identifierController,
          icon: Icons.person,
          hintText: 'Email o Nombre de Usuario',
        ),
        const SizedBox(height: 15),
        _AuthInputField(
          // Asigna el controlador
          controller: _passwordController,
          icon: Icons.lock,
          hintText: 'Contraseña',
          isPassword: true,
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            // 4. Llama al método _handleLogin
            onPressed: _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: accentPink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
            child: const Text(
              'INICIAR SESIÓN',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 5. Modifica _AuthInputField para aceptar un controlador
class _AuthInputField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller; // Añadido

  const _AuthInputField({
    required this.icon,
    required this.hintText,
    required this.controller, // Añadido
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white38),
      ),
      child: TextField(
        controller: controller, // Asignado
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
