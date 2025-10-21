import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vehiculo_provider.dart';
import '../models/vehiculo_model.dart';

class VehiculoFormPage extends StatefulWidget {
  final Vehiculo? vehiculo;
  
  const VehiculoFormPage({super.key, this.vehiculo});

  @override
  State<VehiculoFormPage> createState() => _VehiculoFormPageState();
}

class _VehiculoFormPageState extends State<VehiculoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _anioController = TextEditingController();
  bool _disponible = true;
  bool _isEditing = false;
  late int _vehiculoId;

  @override
  void initState() {
    super.initState();
    _loadVehiculoData();
  }

  void _loadVehiculoData() {
    if (widget.vehiculo != null) {
      _isEditing = true;
      _vehiculoId = widget.vehiculo!.idVehiculo;
      _marcaController.text = widget.vehiculo!.marca;
      _modeloController.text = widget.vehiculo!.modelo;
      _anioController.text = widget.vehiculo!.anio.toString();
      _disponible = widget.vehiculo!.disponible;
    } else {
      _vehiculoId = 0; // Se asignará al guardar
    }
  }

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _anioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Vehículo' : 'Agregar Vehículo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _marcaController,
                decoration: const InputDecoration(
                  labelText: 'Marca',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la marca';
                  }
                  if (value.length < 2) {
                    return 'La marca debe tener al menos 2 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _modeloController,
                decoration: const InputDecoration(
                  labelText: 'Modelo',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el modelo';
                  }
                  if (value.length < 2) {
                    return 'El modelo debe tener al menos 2 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _anioController,
                decoration: const InputDecoration(
                  labelText: 'Año',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el año';
                  }
                  
                  final year = int.tryParse(value);
                  if (year == null) {
                    return 'El año debe ser un número';
                  }
                  
                  final currentYear = DateTime.now().year;
                  if (year < 1900 || year > currentYear + 1) {
                    return 'El año debe estar entre 1900 y ${currentYear + 1}';
                  }
                  
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              SwitchListTile(
                title: const Text('Disponible'),
                value: _disponible,
                onChanged: (value) {
                  setState(() {
                    _disponible = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: _saveVehiculo,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _isEditing ? 'ACTUALIZAR' : 'GUARDAR',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _saveVehiculo() {
    if (_formKey.currentState!.validate()) {
      final vehiculoProvider = Provider.of<VehiculoProvider>(context, listen: false);
      
      final vehiculo = Vehiculo(
        idVehiculo: _isEditing ? _vehiculoId : vehiculoProvider.nextId,
        marca: _marcaController.text,
        modelo: _modeloController.text,
        anio: int.parse(_anioController.text),
        disponible: _disponible,
      );
      
      if (_isEditing) {
        vehiculoProvider.actualizar(vehiculo);
      } else {
        vehiculoProvider.agregar(vehiculo);
      }
      
      Navigator.pop(context);
      
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing 
            ? 'Vehículo actualizado correctamente' 
            : 'Vehículo agregado correctamente'
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}