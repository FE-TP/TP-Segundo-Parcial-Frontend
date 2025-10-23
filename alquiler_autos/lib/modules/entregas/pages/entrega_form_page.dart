import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/entrega_provider.dart';
import '../models/entrega_model.dart';
import '../../reservas/providers/reserva_provider.dart';
import '../../reservas/models/reserva_model.dart';
import '../../vehiculos/providers/vehiculo_provider.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/theme/app_colors.dart';

class EntregaFormPage extends StatefulWidget {
  final Entrega? entrega;

  const EntregaFormPage({super.key, this.entrega});

  @override
  State<EntregaFormPage> createState() => _EntregaFormPageState();
}

class _EntregaFormPageState extends State<EntregaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _kilometrajeController = TextEditingController();
  final _observacionesController = TextEditingController();

  late int _selectedReservaId;
  late DateTime _fechaEntrega;
  bool _isEditing = false;
  late int _entregaId;
  late int _idVehiculo;

  @override
  void initState() {
    super.initState();
    _loadEntregaData();
  }

  void _loadEntregaData() {
    if (widget.entrega != null) {
      _isEditing = true;
      _entregaId = widget.entrega!.idEntrega;
      _selectedReservaId = widget.entrega!.idReserva;
      _idVehiculo = widget.entrega!.idVehiculo;
      _fechaEntrega = widget.entrega!.fechaEntrega;
      _kilometrajeController.text = widget.entrega!.kilometrajeFinal?.toString() ?? '';
      _observacionesController.text = widget.entrega!.observaciones ?? '';
    } else {
      _entregaId = 0;
      _fechaEntrega = DateTime.now();
      _selectedReservaId = 0;
      _idVehiculo = 0;
    }
  }

  @override
  void dispose() {
    _kilometrajeController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Entrega' : 'Registrar Entrega'),
        centerTitle: true,
      ),
      body: Consumer<ReservaProvider>(
        builder: (context, reservaProvider, child) {
          // Obtener solo las reservas activas (confirmadas o pendientes)
          final reservasActivas = reservaProvider.reservas
              .where((r) => r.estado == 'confirmada' || r.estado == 'pendiente')
              .toList();

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildReservaDropdown(reservasActivas),
                const SizedBox(height: 16),
                _buildFechaEntrega(),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _kilometrajeController,
                  labelText: 'Kilometraje Final',
                  hintText: 'Ingrese el kilometraje final',
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.speed),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final kilometraje = double.tryParse(value);
                      if (kilometraje == null) {
                        return 'Ingrese un número válido';
                      }
                      if (kilometraje < 0) {
                        return 'El kilometraje no puede ser negativo';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _observacionesController,
                  labelText: 'Observaciones',
                  hintText: 'Ingrese las observaciones de la entrega',
                  prefixIcon: const Icon(Icons.description),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  onPressed: _selectedReservaId == 0 
                    ? () {} // Función vacía cuando está deshabilitado
                    : _guardarEntrega,
                  text: _isEditing ? 'ACTUALIZAR' : 'REGISTRAR ENTREGA',
                  type: _selectedReservaId == 0 
                    ? CustomButtonType.secondary 
                    : CustomButtonType.primary,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReservaDropdown(List<Reserva> reservasActivas) {
    return DropdownButtonFormField<int>(
      value: _selectedReservaId == 0 ? null : _selectedReservaId,
      decoration: const InputDecoration(
        labelText: 'Reserva',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.bookmark),
      ),
      hint: const Text('Seleccione una reserva'),
      items: reservasActivas.map((reserva) {
        return DropdownMenuItem(
          value: reserva.idReserva,
          child: Text(
            'Reserva #${reserva.idReserva} - ${reserva.clienteNombre} - ${reserva.vehiculoInfo}',
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: _isEditing
          ? null
          : (value) {
              if (value != null) {
                final reserva = reservasActivas
                    .firstWhere((r) => r.idReserva == value);
                setState(() {
                  _selectedReservaId = value;
                  _idVehiculo = reserva.idVehiculo;
                });
              }
            },
      validator: (value) {
        if (value == null || value == 0) {
          return 'Seleccione una reserva';
        }
        return null;
      },
    );
  }

  Widget _buildFechaEntrega() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Fecha de Entrega',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(
          _fechaEntrega.toLocal().toString().split(' ')[0],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaEntrega,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _fechaEntrega) {
      setState(() {
        _fechaEntrega = picked;
      });
    }
  }

  void _guardarEntrega() {
    if (_formKey.currentState?.validate() != true) return;

    final entregaProvider = Provider.of<EntregaProvider>(
      context,
      listen: false,
    );

    final reservaProvider = Provider.of<ReservaProvider>(
      context,
      listen: false,
    );

    final vehiculoProvider = Provider.of<VehiculoProvider>(
      context,
      listen: false,
    );

    // Obtener la reserva seleccionada para los datos del cliente y vehículo
    final reserva = reservaProvider.obtenerPorId(_selectedReservaId);
    if (reserva == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Reserva no encontrada'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Validar que la fecha de entrega no sea anterior a la fecha de inicio de la reserva
    if (_fechaEntrega.isBefore(reserva.fechaInicio)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La fecha de entrega no puede ser anterior a la fecha de inicio de la reserva',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final kilometrajeFinal = _kilometrajeController.text.isNotEmpty
        ? double.parse(_kilometrajeController.text)
        : null;

    final entrega = Entrega(
      idEntrega: _entregaId,
      idReserva: _selectedReservaId,
      idVehiculo: _idVehiculo,
      fechaEntrega: _fechaEntrega,
      kilometrajeFinal: kilometrajeFinal,
      observaciones: _observacionesController.text.trim(),
      clienteNombre: reserva.clienteNombre,
      vehiculoInfo: reserva.vehiculoInfo,
      estado: 'completada',
    );

    if (_isEditing) {
      entregaProvider.actualizar(entrega);
    } else {
      entregaProvider.agregar(entrega, reservaProvider, vehiculoProvider);
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing
              ? 'Entrega actualizada correctamente ✅'
              : 'Entrega registrada correctamente ✅',
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }
}