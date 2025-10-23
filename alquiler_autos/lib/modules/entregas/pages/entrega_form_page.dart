import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/entrega_provider.dart';
import '../models/entrega_model.dart';

class EntregaFormPage extends StatefulWidget {
  const EntregaFormPage({super.key});

  @override
  State<EntregaFormPage> createState() => _EntregaFormPageState();
}

class _EntregaFormPageState extends State<EntregaFormPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime _fechaEntrega = DateTime.now();
  String? _observaciones;
  int? _kilometrajeFinal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Entrega')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Observaciones'),
                onSaved: (value) => _observaciones = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Kilometraje Final'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _kilometrajeFinal = int.tryParse(value ?? ''),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState?.save();
                  final provider = context.read<EntregaProvider>();
                  provider.agregar(
                    Entrega(
                      idEntrega: provider.nextId,
                      idReserva: 1, // Temporal, luego conectar con Reserva
                      fechaEntregaReal: _fechaEntrega,
                      observaciones: _observaciones,
                      kilometrajeFinal: _kilometrajeFinal,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Guardar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
