import 'package:flutter/material.dart';

class ReservasListPage extends StatelessWidget {
  const ReservasListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Módulo de Reservas en desarrollo'),
      ),
    );
  }
}