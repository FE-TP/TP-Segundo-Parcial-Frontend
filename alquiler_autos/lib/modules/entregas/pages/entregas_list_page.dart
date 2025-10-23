import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/entrega_provider.dart';
import '../widgets/entrega_card.dart';

class EntregasListPage extends StatelessWidget {
  const EntregasListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final entregas = context.watch<EntregaProvider>().entregas;

    return Scaffold(
      appBar: AppBar(title: const Text('Entregas')),
      body: entregas.isEmpty
          ? const Center(child: Text('No hay entregas registradas'))
          : ListView.builder(
              itemCount: entregas.length,
              itemBuilder: (context, index) {
                return EntregaCard(entrega: entregas[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/entregas/nueva');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
