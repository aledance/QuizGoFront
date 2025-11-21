import 'package:flutter/material.dart';
// 1. Importa el archivo de la página de registro
import './presentation/authentication/pages/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizGo!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Puedes definir un tema global si lo deseas
        primarySwatch: Colors.purple,
      ),
      // 2. Instancia RegisterPage como la pantalla de inicio
      home: const RegisterPage(),
    );
  }
}
