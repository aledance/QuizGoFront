import 'package:flutter/material.dart';
// Asumiendo que has creado el archivo de colores
import '/core/utils/colors.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Fondo con gradiente morado
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
                // 2. Logo/Título de la aplicación
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

                // 3. Formulario (Simulación sin BLoC/Controladores)
                _buildRegistrationForm(),
                const SizedBox(height: 30),

                // 4. Botón de Navegación a Login
                TextButton(
                  onPressed: () {
                    // Acción para navegar a la página de Login
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
        // Campo de Nombre de Usuario
        _AuthInputField(
          icon: Icons.person,
          hintText: 'Nombre de Usuario',
        ),
        const SizedBox(height: 15),

        // Campo de Correo Electrónico
        _AuthInputField(
          icon: Icons.email,
          hintText: 'Correo Electrónico',
        ),
        const SizedBox(height: 15),

        // Campo de Contraseña
        _AuthInputField(
          icon: Icons.lock,
          hintText: 'Contraseña',
          isPassword: true,
        ),
        const SizedBox(height: 30),

        // Botón Principal de Registro
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              // Lógica para llamar al RegisterUseCase (a través del BLoC/Provider)
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentPink, // Tono rosa para el acento
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

// Widget de Campo de Entrada Reutilizable para Autenticación
class _AuthInputField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool isPassword;

  const _AuthInputField({
    required this.icon,
    required this.hintText,
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