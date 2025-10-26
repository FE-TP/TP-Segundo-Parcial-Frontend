import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/widgets/empty_state.dart';
import '../../reservas/providers/reserva_provider.dart';
import '../models/cliente_model.dart';
import '../pages/cliente_form_page.dart';
import '../providers/cliente_provider.dart';
import '../widgets/cliente_card.dart';
import '../widgets/cliente_filter.dart';

class ClientesListPage extends StatefulWidget {
  const ClientesListPage({super.key});

  @override
  State<ClientesListPage> createState() => _ClientesListPageState();
}

class _ClientesListPageState extends State<ClientesListPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _documentoController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _documentoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ClienteFilter(
              nombreController: _nombreController,
              documentoController: _documentoController,
              onNombreChanged: (_) => setState(() {}),
              onDocumentoChanged: (_) => setState(() {}),
              onClearFilters: _limpiarFiltros,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Consumer2<ClienteProvider, ReservaProvider>(
                builder: (context, clienteProvider, reservaProvider, _) {
                  final clientes = _obtenerClientesFiltrados(
                    clienteProvider,
                    reservaProvider,
                  );

                  if (clientes.isEmpty) {
                    return EmptyState(
                      message: _hayFiltrosActivos
                          ? 'No se encontraron clientes que coincidan con los filtros.'
                          : 'Todavía no registraste clientes.',
                      icon: Icons.person_off,
                      actionLabel: 'Agregar cliente',
                      onActionPressed: () => _abrirFormulario(),
                    );
                  }

                  return ListView.builder(
                    itemCount: clientes.length,
                    itemBuilder: (context, index) {
                      final item = clientes[index];
                      return ClienteCard(
                        cliente: item.cliente,
                        tieneReservasActivas: item.reservasActivas > 0,
                        reservasActivas: item.reservasActivas,
                        onEdit: () => _abrirFormulario(cliente: item.cliente),
                        onDelete: () => _eliminarCliente(item.cliente),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }

  bool get _hayFiltrosActivos =>
      _nombreController.text.trim().isNotEmpty ||
      _documentoController.text.trim().isNotEmpty;

  void _limpiarFiltros() {
    _nombreController.clear();
    _documentoController.clear();
    setState(() {});
  }

  List<_ClienteConReservas> _obtenerClientesFiltrados(
    ClienteProvider clienteProvider,
    ReservaProvider reservaProvider,
  ) {
    final filtrados = clienteProvider.filtrar(
      nombre: _nombreController.text,
      documento: _documentoController.text,
    );

    filtrados.sort(
      (a, b) => '${a.apellido}${a.nombre}'.compareTo('${b.apellido}${b.nombre}'),
    );

    return filtrados.map((cliente) {
      final reservas = reservaProvider.obtenerPorCliente(cliente.idCliente);
      final activas = reservas.where((r) => r.estaActiva).length;
      return _ClienteConReservas(cliente: cliente, reservasActivas: activas);
    }).toList();
  }

  Future<void> _abrirFormulario({Cliente? cliente}) async {
    final resultado = await Navigator.push<ClienteFormResult?>(
      context,
      MaterialPageRoute(
        builder: (context) => ClienteFormPage(cliente: cliente),
      ),
    );

    if (!mounted || resultado == null) return;

    switch (resultado) {
      case ClienteFormResult.creado:
        _mostrarSnackBar('Cliente agregado correctamente');
        break;
      case ClienteFormResult.actualizado:
        _mostrarSnackBar('Cliente actualizado correctamente');
        break;
    }
  }

  Future<void> _eliminarCliente(Cliente cliente) async {
    final reservaProvider = context.read<ReservaProvider>();
    final reservasCliente = reservaProvider.obtenerPorCliente(cliente.idCliente);
    final reservasActivas = reservasCliente.where((r) => r.estaActiva).length;

    if (reservasActivas > 0) {
      _mostrarSnackBar(
        reservasActivas == 1
            ? 'No es posible eliminar al cliente: tiene una reserva activa.'
            : 'No es posible eliminar al cliente: tiene $reservasActivas reservas activas.',
        color: AppColors.error,
      );
      return;
    }

    final confirmado = await ConfirmationDialog.show(
      context: context,
      title: 'Eliminar Cliente',
      message: '¿Desea eliminar a ${cliente.nombre} ${cliente.apellido}?',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      isDestructiveAction: true,
    );

    if (confirmado != true || !mounted) return;

    context.read<ClienteProvider>().eliminar(cliente.idCliente);
    _mostrarSnackBar('Cliente eliminado correctamente');
  }

  void _mostrarSnackBar(String mensaje, {Color color = AppColors.success}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: color,
      ),
    );
  }
}

class _ClienteConReservas {
  final Cliente cliente;
  final int reservasActivas;

  _ClienteConReservas({required this.cliente, required this.reservasActivas});
}