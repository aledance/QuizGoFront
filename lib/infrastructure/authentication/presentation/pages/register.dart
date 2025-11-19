import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/user/models/user.dart';
// Corregí la ruta de importación para que sea más estándar, asumiendo la estructura de tu proyecto.
import 'package:flutter_application_1/infrastructure/home/presentation/home.dart';
import './login.dart';
import '/core/utils/colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 1. Asignamos los datos de ejemplo a los controladores al iniciar el widget
    _usernameController.text = 'jrmat';
    _emailController.text = 'jrmat@email.com';
    _passwordController.text = '123';
  }

  void _handleRegister() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // 2. Lógica de validación con mensajes de error específicos
    if (username.length < 3) {
      _showErrorSnackBar('El nombre de usuario debe tener al menos 3 caracteres.');
      return;
    }

    // Expresión regular simple para validar el formato del email
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      _showErrorSnackBar('Por favor, introduce un correo electrónico válido.');
      return;
    }

    if (password.length < 3) {
      _showErrorSnackBar('La contraseña debe tener al menos 3 caracteres.');
      return;
    }

    // --- INICIO DE LA SIMULACIÓN DE REGISTRO ---

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Registro exitoso! Bienvenido.'),
        backgroundColor: Colors.green,
      ),
    );

    // Creamos la instancia del usuario con los datos validados
    final newUser = User(
      username: username,
      email: email,
    );

    // Navegamos a la HomePage, limpiando las rutas anteriores
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => HomePage(user: newUser)),
          (route) => false,
    );
    // --- FIN DE LA SIMULACIÓN ---
  }

  // Función de ayuda para mostrar mensajes de error
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
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
                  'Crea tu cuenta',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 40),
                _buildRegistrationForm(),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    '¿Ya tienes cuenta? Inicia sesión',
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

  Widget _buildRegistrationForm() {
    return Column(
      children: [
        _AuthInputField(
          controller: _usernameController,
          icon: Icons.person,
          hintText: 'Nombre de Usuario',
        ),
        const SizedBox(height: 15),
        _AuthInputField(
          controller: _emailController,
          icon: Icons.email,
          hintText: 'Correo Electrónico',
        ),
        const SizedBox(height: 15),
        _AuthInputField(
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
            onPressed: _handleRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: accentPink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
            child: const Text(
              'REGISTRARSE',
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

// El widget _AuthInputField no necesita cambios
class _AuthInputField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;

  const _AuthInputField({
    required this.icon,
    required this.hintText,
    required this.controller,
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
        controller: controller,
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
