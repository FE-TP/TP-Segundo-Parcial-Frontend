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
  int? _vehiculoId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final vehiculo = ModalRoute.of(context)?.settings.arguments as Vehiculo?;
    
    if (vehiculo != null && !_isEditing) {
      _marcaController.text = vehiculo.marca;
      _modeloController.text = vehiculo.modelo;
      _anioController.text = vehiculo.anio.toString();
      _disponible = vehiculo.disponible;
      _vehiculoId = vehiculo.idVehiculo;
      _isEditing = true;
    }
  }

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _anioController.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      final vehiculoProvider = Provider.of<VehiculoProvider>(context, listen: false);
      final anio = int.parse(_anioController.text);
      
      if (_isEditing && _vehiculoId != null) {
        // Actualizar vehículo existente
        final vehiculoActualizado = Vehiculo(
          idVehiculo: _vehiculoId!,
          marca: _marcaController.text,
          modelo: _modeloController.text,
          anio: anio,
          disponible: _disponible,
        );
        
        vehiculoProvider.actualizar(vehiculoActualizado);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehículo actualizado correctamente')),
        );
      } else {
        // Crear nuevo vehículo
        final nuevoVehiculo = Vehiculo(
          idVehiculo: vehiculoProvider.nextId,
          marca: _marcaController.text,
          modelo: _modeloController.text,
          anio: anio,
          disponible: _disponible,
        );
        
        vehiculoProvider.agregar(nuevoVehiculo);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehículo agregado correctamente')),
        );
      }
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    
    return Scaffold(
      appBar: CustomAppBar(
        title: _isEditing ? Constants.editarVehiculo : Constants.agregarVehiculo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo Marca
              CustomTextField(
                labelText: Constants.marcaLabel,
                controller: _marcaController,
                textCapitalization: TextCapitalization.words,
                validator: (value) => Validators.combine([
                  Validators.required,
                  (value) => Validators.minLength(value, 2),
                ], value),
              ),
              const SizedBox(height: 16),
              
              // Campo Modelo
              CustomTextField(
                labelText: Constants.modeloLabel,
                controller: _modeloController,
                textCapitalization: TextCapitalization.words,
                validator: (value) => Validators.combine([
                  Validators.required,
                  (value) => Validators.minLength(value, 2),
                ], value),
              ),
              const SizedBox(height: 16),
              
              // Campo Año
              CustomTextField(
                labelText: Constants.anioLabel,
                controller: _anioController,
                keyboardType: TextInputType.number,
                validator: (value) => Validators.combine([
                  Validators.required,
                  Validators.onlyNumbers,
                  (value) => Validators.yearRange(value, minYear: 1900, maxYear: currentYear + 1),
                ], value),
              ),
              const SizedBox(height: 16),
              
              // Campo Disponible
              SwitchListTile(
                title: const Text(Constants.disponibleLabel),
                value: _disponible,
                onChanged: (value) {
                  setState(() {
                    _disponible = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    text: Constants.cancelar,
                    onPressed: () => Navigator.pop(context),
                    type: CustomButtonType.outline,
                  ),
                  const SizedBox(width: 16),
                  CustomButton(
                    text: Constants.guardar,
                    onPressed: _guardar,
                    type: CustomButtonType.primary,
                    icon: Icons.save,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}