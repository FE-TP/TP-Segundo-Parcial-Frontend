import 'package:flutter/material.dart';

class EstadisticasPage extends StatelessWidget {
  const EstadisticasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Módulo de Estadísticas en desarrollo'),
      ),
    );
  }
}