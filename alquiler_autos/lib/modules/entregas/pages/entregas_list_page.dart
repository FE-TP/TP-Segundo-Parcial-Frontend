import 'package:flutter/material.dart';

class EntregasListPage extends StatelessWidget {
  const EntregasListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entregas'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Módulo de Entregas en desarrollo'),
      ),
    );
  }
}