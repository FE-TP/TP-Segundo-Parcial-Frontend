import 'package:flutter/material.dart';

class ClientesListPage extends StatelessWidget {
  const ClientesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Módulo de Clientes en desarrollo'),
      ),
    );
  }
}