import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cliente_model.dart';
import '../providers/cliente_provider.dart';

class ClienteFormPage extends StatefulWidget {
  static const String route = '/clientes/form';
  
  final Cliente? cliente;
  
  const ClienteFormPage({super.key, this.cliente});

  @override
  State<ClienteFormPage> createState() => _ClienteFormPageState();
}

class _ClienteFormPageState extends State<ClienteFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _documentoController = TextEditingController();
  
  bool _esEdicion = false;
  late int _clienteId;
  
  @override
  void initState() {
    super.initState();
    
    if (widget.cliente != null) {
      _esEdicion = true;
      _clienteId = widget.cliente!.idCliente;
      _nombreController.text = widget.cliente!.nombre;
      _apellidoController.text = widget.cliente!.apellido;
      _documentoController.text = widget.cliente!.numeroDocumento;
    } else {
      _clienteId = 0; // Se asignará el ID al guardar
    }
  }
  
  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _documentoController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar Cliente' : 'Nuevo Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _apellidoController,
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el apellido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _documentoController,
                decoration: const InputDecoration(
                  labelText: 'Número de Documento',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el número de documento';
                  }
                  
                  final clienteProvider = Provider.of<ClienteProvider>(context, listen: false);
                  final documentoExiste = clienteProvider.documentoExiste(
                    value,
                    excludeId: _esEdicion ? _clienteId : null,
                  );
                  
                  if (documentoExiste) {
                    return 'Este documento ya está registrado';
                  }
                  
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: _guardarCliente,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _esEdicion ? 'ACTUALIZAR' : 'GUARDAR',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _guardarCliente() {
    if (_formKey.currentState!.validate()) {
      final clienteProvider = Provider.of<ClienteProvider>(context, listen: false);
      
      final cliente = Cliente(
        idCliente: _esEdicion ? _clienteId : clienteProvider.nextId,
        nombre: _nombreController.text,
        apellido: _apellidoController.text,
        numeroDocumento: _documentoController.text,
      );
      
      if (_esEdicion) {
        clienteProvider.actualizar(cliente);
      } else {
        clienteProvider.agregar(cliente);
      }
      
      Navigator.of(context).pop();
      
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_esEdicion 
            ? 'Cliente actualizado correctamente' 
            : 'Cliente agregado correctamente'
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}