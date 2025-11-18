import 'package:flutter/material.dart';

void main() {
  runApp(const ApplicationSimulation());
}

class ApplicationSimulation extends StatelessWidget {
  const ApplicationSimulation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application Simulation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SimulationHomePage(),
    );
  }
}

class SimulationHomePage extends StatelessWidget {
  const SimulationHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulation Home Page'),
      ),
      body: const Center(
        child: Text('This is a simulation for the application layer.'),
      ),
    );
  }
}
