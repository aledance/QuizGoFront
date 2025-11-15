import 'package:flutter/material.dart';
// Asegúrate de importar tus archivos de colores, perfil y el modelo de usuario
import '/core/utils/colors.dart';
import '/infrastructure/authentication/presentation/pages/user_profile.dart'; // Importa la vista de perfil
import '/domain/user/models/user.dart'; // Importa el modelo de usuario

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Mismo fondo de gradiente para coherencia
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryPurple, darkPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2. Encabezado con bienvenida y acceso al perfil
              _buildHeader(context, user),

              const SizedBox(height: 30),

              // Título de la sección principal
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Elige un modo de juego',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),


            ],
          ),
        ),
      ),
    );
  }

  // Widget para el encabezado
  Widget _buildHeader(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Mensaje de bienvenida
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hola de nuevo,',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 18,
                ),
              ),
              Text(
                user.username,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Botón para ir al perfil
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProfilePage(user: user),
                ),
              );
            },
            child: const CircleAvatar(
              radius: 30,
              backgroundColor: accentPink,
              child: Icon(Icons.person, color: Colors.white, size: 35),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para las tarjetas de modo de juego
  Widget _buildGameModeCard(BuildContext context,
      {required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
