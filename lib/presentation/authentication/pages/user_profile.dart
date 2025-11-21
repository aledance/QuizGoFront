// lib/infrastructure/authentication/presentation/pages/user_profile.dart

import 'package:flutter/material.dart';
// Asegúrate de importar tus archivos necesarios
import '/domain/user/models/user.dart'; // <<<--- 1. IMPORTA EL MODELO USER
import './login.dart';

class ProfilePage extends StatelessWidget {
  // <<<--- 2. AÑADE LA PROPIEDAD PARA RECIBIR EL USUARIO
  final User user;

  // <<<--- 3. ACTUALIZA EL CONSTRUCTOR PARA REQUERIR EL USUARIO
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo (se eliminan o se usan como fallback)
    const int gamesPlayed = 128;
    const int gamesWon = 76;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.amber,
                child: Icon(
                  Icons.person,
                  size: 70,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // <<<--- 4. USA LOS DATOS REALES DEL USUARIO
              Text(
                user.username, // Usa el username del objeto user
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.email, // Usa el email del objeto user
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 40),
              _buildStatsSection(gamesPlayed, gamesWon),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                            (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
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
