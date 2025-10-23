import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reserva_provider.dart';
import '../models/reserva_model.dart';
import 'reserva_form_page.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../vehiculos/providers/vehiculo_provider.dart';

class ReservasListPage extends StatefulWidget {
  const ReservasListPage({super.key});

  @override
  State<ReservasListPage> createState() => _ReservasListPageState();
}

class _ReservasListPageState extends State<ReservasListPage> {
  String _searchQuery = '';
  String _filtroEstado = 'todas';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reservas'), centerTitle: true),
      body: Column(
        children: [
          _buildFilterSection(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Sugerencia: Puedes buscar por cliente, vehículo o ID y filtrar por estado',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Consumer<ReservaProvider>(
              builder: (context, provider, child) {
                final reservas = _getFilteredReservas(provider);
                final totalReservas = provider.reservas.length;

                if (reservas.isEmpty &&
                    (_searchQuery.isNotEmpty || _filtroEstado != 'todas')) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _filtroEstado != 'todas' && _searchQuery.isEmpty
                              ? 'No hay reservas con estado "$_filtroEstado"'
                              : 'No se encontraron reservas que coincidan con los filtros',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_searchQuery.isNotEmpty)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                                child: const Text('Limpiar búsqueda'),
                              ),
                            if (_filtroEstado != 'todas')
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _filtroEstado = 'todas';
                                  });
                                },
                                child: const Text('Mostrar todas'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (reservas.isEmpty) {
                  return EmptyState(
                    message: 'No hay reservas registradas',
                    icon: Icons.event_busy,
                    actionLabel: 'Crear Primera Reserva',
                    onActionPressed: () => _navigateToForm(context),
                  );
                }

                return Column(
                  children: [
                    if (_searchQuery.isNotEmpty || _filtroEstado != 'todas')
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Mostrando ${reservas.length} de $totalReservas reservas',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: reservas.length,
                        itemBuilder: (context, index) =>
                            _buildReservaItem(context, reservas[index]),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar por cliente, vehículo o ID',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildEstadoChip('todas', 'Todas'),
                _buildEstadoChip('pendiente', 'Pendientes'),
                _buildEstadoChip('confirmada', 'Confirmadas'),
                _buildEstadoChip('cancelada', 'Canceladas'),
                _buildEstadoChip('finalizada', 'Finalizadas'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadoChip(String valor, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: _filtroEstado == valor,
        onSelected: (selected) {
          setState(() {
            _filtroEstado = valor;
          });
        },
      ),
    );
  }

  Widget _buildReservaItem(BuildContext context, Reserva reserva) {
    final estadoColor = _getEstadoColor(reserva.estado);
    final estadoIcon = _getEstadoIcon(reserva.estado);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: estadoColor.withOpacity(0.2),
          child: Icon(estadoIcon, color: estadoColor),
        ),
        title: Text(reserva.clienteNombre ?? 'Cliente #${reserva.idCliente}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reserva.vehiculoInfo ?? 'Vehículo #${reserva.idVehiculo}'),
            Text(
              '${DateFormatter.formatDate(reserva.fechaInicio)} - ${DateFormatter.formatDate(reserva.fechaFin)} (${reserva.diasReserva} días)',
              style: const TextStyle(fontSize: 12),
            ),
            if (reserva.montoTotal != null)
              Text(
                'Total: \$${reserva.montoTotal!.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(
                reserva.estado.toUpperCase(),
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
              backgroundColor: estadoColor,
              padding: EdgeInsets.zero,
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'editar') {
                  _navigateToForm(context, reserva: reserva);
                } else if (value == 'eliminar') {
                  _confirmarEliminar(context, reserva.idReserva);
                } else {
                  _cambiarEstado(context, reserva, value);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'editar', child: Text('Editar')),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'pendiente',
                  child: Text('⏳ Marcar Pendiente'),
                ),
                const PopupMenuItem(
                  value: 'confirmada',
                  child: Text('✅ Marcar Confirmada'),
                ),
                const PopupMenuItem(
                  value: 'cancelada',
                  child: Text('❌ Marcar Cancelada'),
                ),
                const PopupMenuItem(
                  value: 'finalizada',
                  child: Text('✔️ Marcar Finalizada'),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'eliminar',
                  child: Text('Eliminar', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _navigateToForm(context, reserva: reserva),
      ),
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case 'pendiente':
        return AppColors.warning;
      case 'confirmada':
        return AppColors.success;
      case 'cancelada':
        return AppColors.error;
      case 'finalizada':
        return AppColors.textLight;
      default:
        return AppColors.primary;
    }
  }

  IconData _getEstadoIcon(String estado) {
    switch (estado) {
      case 'pendiente':
        return Icons.pending;
      case 'confirmada':
        return Icons.check_circle;
      case 'cancelada':
        return Icons.cancel;
      case 'finalizada':
        return Icons.done_all;
      default:
        return Icons.info;
    }
  }

  List<Reserva> _getFilteredReservas(ReservaProvider provider) {
    var reservas = provider.reservas;

    // Aplicar filtro de estado
    if (_filtroEstado != 'todas') {
      reservas = reservas.where((r) => r.estado == _filtroEstado).toList();
    }

    // Aplicar filtro de texto
    if (_searchQuery.isEmpty) {
      return reservas;
    }

    final query = _searchQuery.toLowerCase();
    return reservas.where((r) {
      return r.idReserva.toString().contains(query) ||
          (r.clienteNombre?.toLowerCase().contains(query) ?? false) ||
          (r.vehiculoInfo?.toLowerCase().contains(query) ?? false) ||
          r.idCliente.toString().contains(query) ||
          r.idVehiculo.toString().contains(query);
    }).toList();
  }

  void _navigateToForm(BuildContext context, {Reserva? reserva}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservaFormPage(reserva: reserva),
      ),
    );
  }

  void _cambiarEstado(
    BuildContext context,
    Reserva reserva,
    String nuevoEstado,
  ) {
    final reservaProvider = Provider.of<ReservaProvider>(
      context,
      listen: false,
    );
    final vehiculoProvider = Provider.of<VehiculoProvider>(
      context,
      listen: false,
    );

    final estadoAnterior = reserva.estado;
    reservaProvider.cambiarEstado(reserva.idReserva, nuevoEstado);

    // Actualizar disponibilidad del vehículo según el nuevo estado
    if (nuevoEstado == 'cancelada' || nuevoEstado == 'finalizada') {
      // Verificar si hay otras reservas activas para este vehículo
      final reservasActivas = reservaProvider.obtenerReservasActivasPorVehiculo(
        reserva.idVehiculo,
      );

      // Solo liberar si no hay otras reservas activas
      if (reservasActivas.isEmpty) {
        vehiculoProvider.actualizarDisponibilidad(reserva.idVehiculo, true);
      }
    } else if ((nuevoEstado == 'confirmada' || nuevoEstado == 'pendiente') &&
        (estadoAnterior == 'cancelada' || estadoAnterior == 'finalizada')) {
      // Si se reactiva una reserva desde cancelada/finalizada, marcar vehículo como no disponible
      vehiculoProvider.actualizarDisponibilidad(reserva.idVehiculo, false);
    }

    String mensaje = 'Estado actualizado a "${nuevoEstado.toUpperCase()}"';
    Color backgroundColor = AppColors.success;

    // Mensaje personalizado según el cambio
    if (nuevoEstado == 'cancelada' || nuevoEstado == 'finalizada') {
      final reservasActivas = reservaProvider.obtenerReservasActivasPorVehiculo(
        reserva.idVehiculo,
      );
      if (reservasActivas.isEmpty) {
        mensaje += '\nVehículo ahora disponible ✅';
      }
    } else if (nuevoEstado == 'confirmada' || nuevoEstado == 'pendiente') {
      mensaje += '\nVehículo marcado como no disponible ⚠️';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _confirmarEliminar(BuildContext context, int idReserva) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Eliminar Reserva',
      message: '¿Está seguro que desea eliminar esta reserva?',
      confirmText: 'ELIMINAR',
      cancelText: 'CANCELAR',
      isDestructiveAction: true,
    );

    if (confirmed == true) {
      if (!context.mounted) return;

      final reservaProvider = Provider.of<ReservaProvider>(
        context,
        listen: false,
      );
      final vehiculoProvider = Provider.of<VehiculoProvider>(
        context,
        listen: false,
      );

      // Obtener la reserva antes de eliminarla
      final reserva = reservaProvider.obtenerPorId(idReserva);

      if (reserva != null) {
        final idVehiculo = reserva.idVehiculo;
        reservaProvider.eliminar(idReserva);

        // Liberar vehículo si no tiene otras reservas activas
        final reservasActivas = reservaProvider
            .obtenerReservasActivasPorVehiculo(idVehiculo);
        if (reservasActivas.isEmpty) {
          vehiculoProvider.actualizarDisponibilidad(idVehiculo, true);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Reserva eliminada correctamente\nVehículo ahora disponible ✅',
              ),
              backgroundColor: AppColors.success,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reserva eliminada correctamente'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    }
  }
}
