import 'package:flutter/material.dart';
// Asegúrate de importar tus archivos necesarios
// Las siguientes 3 importaciones no son estrictamente necesarias para esta simulación, pero las mantenemos
import 'package:flutter_application_1/core/repositories/auth_repository.dart';
import 'package:flutter_application_1/infrastructure/authentication/data/repositories/auth_repository_impl.dart';
import 'package:flutter_application_1/infrastructure/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:http/http.dart' as http;

// Importaciones para navegación
import './register.dart';
import '/core/utils/colors.dart';
import '/domain/user/models/user.dart';
import '../../../home/presentation/home.dart';


// Convertido a StatefulWidget
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores para los campos de texto
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  // Dependencia del repositorio (no se usará en esta simulación, pero se mantiene la estructura)
  late final AuthRepository authRepository;

  @override
  void initState() {
    super.initState();
    authRepository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(client: http.Client()),
    );
  }

  // <<<--- 2. LÓGICA DE LOGIN MODIFICADA
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

    // ---- INICIO DE LA SIMULACIÓN ----
    // Comprueba si las credenciales coinciden con las especificadas
    if (identifier == 'jrmat@email.com' && password == '123') {
      // Éxito: Muestra el mensaje emergente
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inicio de sesión exitoso!'),
          backgroundColor: Colors.green,
        ),
      );

      // Datos del usuario para pasar a la siguiente pantalla
      final User user = User(
        username: 'jrmat',
        email: 'jrmat@email.com',
      );

      // Navega a la nueva HomePage, pasando los datos del usuario
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage(user: user)),
      );
    } else {
      // Fallo: Muestra un error de credenciales inválidas
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Credenciales inválidas. Inténtelo de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
    // ---- FIN DE LA SIMULACIÓN ----

    /*
    // --- CÓDIGO ORIGINAL DE LA API (AHORA COMENTADO) ---
    try {
      final token = await authRepository.login(identifier, password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inicio de sesión exitoso! Token: ${token.substring(0, 10)}...')),
      );
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ProfilePage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error inesperado: $e')),
      );
    }
    */
  }
  // <<<--- FIN DE LA MODIFICACIÓN

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
          controller: _identifierController,
          icon: Icons.person,
          hintText: 'Email o Nombre de Usuario',
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

// Modifica _AuthInputField para aceptar un controlador
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
