import 'package:flutter/material.dart';
// Asegúrate de importar tu archivo de colores y las páginas de login/register
import '/core/utils/colors.dart';
import '/infrastructure/authentication/presentation/pages/login.dart';

class ProfilePage extends StatelessWidget {
  // En una aplicación real, recibirías el objeto User aquí.
  // const ProfilePage({super.key, required this.user});
  // final User user;

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo. Deberían venir del estado de la app o de un objeto User.
    const String username = 'jrmat';
    const String email = 'jrmat@email.com';
    const int gamesPlayed = 128;
    const int gamesWon = 76;

    return Scaffold(
      // 1. Mismo fondo de gradiente para mantener la consistencia visual.
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryPurple, darkPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Botón para volver o cerrar (opcional)
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(height: 20),

              // 2. Avatar del Usuario
              const CircleAvatar(
                radius: 60,
                backgroundColor: accentPink,
                child: Icon(
                  Icons.person,
                  size: 70,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // 3. Nombre de Usuario y Correo
              Text(
                username,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 40),

              // 4. Sección de Estadísticas
              _buildStatsSection(gamesPlayed, gamesWon),
              const Spacer(), // Empuja el botón de logout hacia abajo

              // 5. Botón de Cerrar Sesión
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // Lógica para cerrar sesión
                      // Navega a la página de login y elimina todas las rutas anteriores
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                            (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentPink, // Mismo color de acento
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'CERRAR SESIÓN',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para construir la sección de estadísticas
  Widget _buildStatsSection(int games, int wins) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white38),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildStatItem('Partidas', games.toString()),
            _buildStatItem('Victorias', wins.toString()),
            // Puedes agregar más estadísticas aquí
            _buildStatItem('Ratio', '${((wins / games) * 100).toStringAsFixed(1)}%'),
          ],
        ),
      ),
    );
  }

  // Widget para un item individual de estadística
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
