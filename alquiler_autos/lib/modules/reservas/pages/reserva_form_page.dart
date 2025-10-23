import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reserva_provider.dart';
import '../models/reserva_model.dart';
import '../models/cliente_temp.dart';
import '../../vehiculos/providers/vehiculo_provider.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/theme/app_colors.dart';

class ReservaFormPage extends StatefulWidget {
  final Reserva? reserva;

  const ReservaFormPage({super.key, this.reserva});

  @override
  State<ReservaFormPage> createState() => _ReservaFormPageState();
}

class _ReservaFormPageState extends State<ReservaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  final _observacionesController = TextEditingController();

  int? _selectedClienteId;
  int? _selectedVehiculoId;
  late DateTime _fechaInicio;
  late DateTime _fechaFin;
  late String _estado;
  bool _isEditing = false;
  late int _reservaId;

  @override
  void initState() {
    super.initState();
    _loadReservaData();
  }

  void _loadReservaData() {
    if (widget.reserva != null) {
      _isEditing = true;
      _reservaId = widget.reserva!.idReserva;
      _selectedClienteId = widget.reserva!.idCliente;
      _selectedVehiculoId = widget.reserva!.idVehiculo;
      _fechaInicio = widget.reserva!.fechaInicio;
      _fechaFin = widget.reserva!.fechaFin;
      _estado = widget.reserva!.estado;
      _montoController.text = widget.reserva!.montoTotal?.toString() ?? '';
      _observacionesController.text = widget.reserva!.observaciones ?? '';
    } else {
      _reservaId = 0;
      _fechaInicio = DateTime.now();
      _fechaFin = DateTime.now().add(const Duration(days: 1));
      _estado = 'pendiente';
    }
  }

  @override
  void dispose() {
    _montoController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Reserva' : 'Nueva Reserva'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Información contextual
              if (_isEditing)
                Card(
                  color: AppColors.info.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.info),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Editando Reserva',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'ID: ${widget.reserva!.idReserva} | Creada: ${DateFormatter.formatDate(widget.reserva!.fechaReserva)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_isEditing) const SizedBox(height: 16),

              // Selector de Cliente
              _buildClienteSelector(),
              const SizedBox(height: 16),

              // Selector de Vehículo
              _buildVehiculoSelector(),
              const SizedBox(height: 16),

              // Fechas
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.calendar_today,
                    color: AppColors.primary,
                  ),
                  title: const Text('Fecha de Inicio'),
                  subtitle: Text(
                    DateFormatter.formatDate(_fechaInicio),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.edit),
                  onTap: () => _selectDate(context, true),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.event, color: AppColors.success),
                  title: const Text('Fecha de Fin'),
                  subtitle: Text(
                    DateFormatter.formatDate(_fechaFin),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.edit),
                  onTap: () => _selectDate(context, false),
                ),
              ),
              const SizedBox(height: 8),

              // Duración
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.warning),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.access_time, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Text(
                      'Duración: ${_fechaFin.difference(_fechaInicio).inDays} día(s)',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Estado
              DropdownButtonFormField<String>(
                value: _estado,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.info_outline),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'pendiente',
                    child: Text('⏳ Pendiente'),
                  ),
                  DropdownMenuItem(
                    value: 'confirmada',
                    child: Text('✅ Confirmada'),
                  ),
                  DropdownMenuItem(
                    value: 'cancelada',
                    child: Text('❌ Cancelada'),
                  ),
                  DropdownMenuItem(
                    value: 'finalizada',
                    child: Text('✔️ Finalizada'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _estado = value!;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleccione un estado' : null,
              ),
              const SizedBox(height: 16),

              // Monto
              CustomTextField(
                labelText: 'Monto Total',
                hintText: '0.00',
                controller: _montoController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.attach_money),
              ),
              const SizedBox(height: 16),

              // Observaciones
              CustomTextField(
                labelText: 'Observaciones',
                hintText: 'Comentarios adicionales (opcional)',
                controller: _observacionesController,
                maxLines: 3,
                prefixIcon: const Icon(Icons.note),
              ),
              const SizedBox(height: 24),

              // Botón Guardar/Actualizar
              ElevatedButton(
                onPressed: _saveReserva,
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

  Widget _buildClienteSelector() {
    final clientes = ClientesData.clientes;

    return DropdownButtonFormField<int>(
      value: _selectedClienteId,
      decoration: const InputDecoration(
        labelText: 'Cliente *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
        hintText: 'Seleccione un cliente',
      ),
      isExpanded: true,
      items: clientes.map((cliente) {
        return DropdownMenuItem<int>(
          value: cliente.id,
          child: Text('${cliente.nombre} - DNI: ${cliente.dni}'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedClienteId = value;
        });
      },
      validator: (value) =>
          value == null ? 'Debe seleccionar un cliente' : null,
    );
  }

  Widget _buildVehiculoSelector() {
    return Consumer<VehiculoProvider>(
      builder: (context, vehiculoProvider, child) {
        final vehiculos = vehiculoProvider.vehiculos;
        final vehiculosDisponibles = vehiculos
            .where((v) => v.disponible)
            .toList();

        // Si estamos editando, incluir el vehículo actual aunque no esté disponible
        if (_isEditing && _selectedVehiculoId != null) {
          final vehiculoActual = vehiculos.firstWhere(
            (v) => v.idVehiculo == _selectedVehiculoId,
            orElse: () => vehiculos.first,
          );
          if (!vehiculosDisponibles.any(
            (v) => v.idVehiculo == vehiculoActual.idVehiculo,
          )) {
            vehiculosDisponibles.add(vehiculoActual);
          }
        }

        if (vehiculosDisponibles.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.error),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning, color: AppColors.error),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No hay vehículos disponibles en este momento',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              value: _selectedVehiculoId,
              decoration: InputDecoration(
                labelText: 'Vehículo *',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.directions_car),
                hintText: 'Seleccione un vehículo',
                helperText: _isEditing
                    ? 'No se puede cambiar el vehículo al editar'
                    : '${vehiculosDisponibles.length} vehículo(s) disponible(s)',
                helperStyle: TextStyle(
                  color: _isEditing ? AppColors.warning : null,
                  fontWeight: _isEditing ? FontWeight.bold : null,
                ),
                enabled: !_isEditing,
                fillColor: _isEditing ? Colors.grey[100] : null,
                filled: _isEditing,
              ),
              isExpanded: true,
              items: vehiculosDisponibles.map((vehiculo) {
                return DropdownMenuItem<int>(
                  value: vehiculo.idVehiculo,
                  child: Text(
                    '${vehiculo.marca} ${vehiculo.modelo} (${vehiculo.anio})${!vehiculo.disponible ? " ⚠️" : ""}',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: _isEditing
                  ? null
                  : (value) {
                      setState(() {
                        _selectedVehiculoId = value;
                      });
                    },
              validator: (value) =>
                  value == null ? 'Debe seleccionar un vehículo' : null,
            ),
            if (_isEditing && _selectedVehiculoId != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.info),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock, color: AppColors.info, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'El vehículo no puede ser modificado en una reserva existente',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _fechaInicio : _fechaFin,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _fechaInicio = picked;
          if (_fechaInicio.isAfter(_fechaFin)) {
            _fechaFin = _fechaInicio.add(const Duration(days: 1));
          }
        } else {
          if (picked.isBefore(_fechaInicio)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'La fecha de fin debe ser posterior a la de inicio',
                ),
                backgroundColor: AppColors.error,
              ),
            );
            return;
          }
          _fechaFin = picked;
        }
      });
    }
  }

  void _saveReserva() {
    if (_formKey.currentState!.validate()) {
      if (_selectedClienteId == null || _selectedVehiculoId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debe seleccionar un cliente y un vehículo'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final reservaProvider = Provider.of<ReservaProvider>(
        context,
        listen: false,
      );
      final vehiculoProvider = Provider.of<VehiculoProvider>(
        context,
        listen: false,
      );

      // Obtener información del cliente y vehículo
      final cliente = ClientesData.obtenerPorId(_selectedClienteId!);
      final vehiculo = vehiculoProvider.vehiculos.firstWhere(
        (v) => v.idVehiculo == _selectedVehiculoId,
      );

      // Guardar el estado anterior si estamos editando
      final estadoAnterior = _isEditing ? widget.reserva!.estado : null;

      final reserva = Reserva(
        idReserva: _isEditing ? _reservaId : reservaProvider.nextId,
        idCliente: _selectedClienteId!,
        idVehiculo: _selectedVehiculoId!,
        fechaReserva: _isEditing
            ? widget.reserva!.fechaReserva
            : DateTime.now(),
        fechaInicio: _fechaInicio,
        fechaFin: _fechaFin,
        estado: _estado,
        montoTotal: _montoController.text.isNotEmpty
            ? double.tryParse(_montoController.text)
            : null,
        observaciones: _observacionesController.text.isNotEmpty
            ? _observacionesController.text
            : null,
        clienteNombre: cliente?.nombre,
        vehiculoInfo: vehiculo.toString(),
      );

      if (_isEditing) {
        reservaProvider.actualizar(reserva);

        // Si cambió el estado, actualizar disponibilidad del vehículo
        if (estadoAnterior != _estado) {
          _actualizarDisponibilidadVehiculo(
            vehiculoProvider,
            _selectedVehiculoId!,
            _estado,
          );
        }
      } else {
        reservaProvider.agregar(reserva);

        // Si la reserva es confirmada o pendiente, marcar vehículo como no disponible
        if (_estado == 'confirmada' || _estado == 'pendiente') {
          vehiculoProvider.actualizarDisponibilidad(
            _selectedVehiculoId!,
            false,
          );
        }
      }

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Reserva actualizada correctamente'
                : 'Reserva creada correctamente',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  /// Actualiza la disponibilidad del vehículo según el estado de la reserva
  void _actualizarDisponibilidadVehiculo(
    VehiculoProvider vehiculoProvider,
    int idVehiculo,
    String estado,
  ) {
    // Si el estado es cancelado o finalizado, liberar el vehículo
    if (estado == 'cancelada' || estado == 'finalizada') {
      final reservaProvider = Provider.of<ReservaProvider>(
        context,
        listen: false,
      );
      final reservasActivas = reservaProvider.obtenerReservasActivasPorVehiculo(
        idVehiculo,
      );

      // Solo liberar si no hay otras reservas activas
      if (reservasActivas.isEmpty) {
        vehiculoProvider.actualizarDisponibilidad(idVehiculo, true);
      }
    } else if (estado == 'confirmada' || estado == 'pendiente') {
      // Si se confirma o está pendiente, marcar como no disponible
      vehiculoProvider.actualizarDisponibilidad(idVehiculo, false);
    }
  }
}
