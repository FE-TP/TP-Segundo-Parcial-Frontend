import 'package:flutter/material.dart';
import '../models/entrega_model.dart';

class EntregaCard extends StatelessWidget {
  final Entrega entrega;
  const EntregaCard({super.key, required this.entrega});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        title: Text('Entrega ID: ${entrega.idEntrega}'),
        subtitle: Text('Fecha: ${entrega.fechaEntregaReal.toLocal()}'),
        trailing: Text(entrega.kilometrajeFinal != null ? '${entrega.kilometrajeFinal} km' : ''),
      ),
    );
  }
}
