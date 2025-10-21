import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vehiculo_provider.dart';
import '../models/vehiculo_model.dart';
import '../widgets/vehiculo_card.dart';
import '../widgets/vehiculo_filter.dart';

class VehiculosListPage extends StatefulWidget {
  const VehiculosListPage({super.key});

  @override
  State<VehiculosListPage> createState() => _VehiculosListPageState();
}

class _VehiculosListPageState extends State<VehiculosListPage> {
  String _marcaFilter = '';
  String _modeloFilter = '';

  List<Vehiculo> _getFilteredList(VehiculoProvider provider) {
    if (_marcaFilter.isNotEmpty && _modeloFilter.isNotEmpty) {
      final porMarca = provider.filtrarPorMarca(_marcaFilter);
      return porMarca.where(
        (v) => v.modelo.toLowerCase().contains(_modeloFilter.toLowerCase())
      ).toList();
    } else if (_marcaFilter.isNotEmpty) {
      return provider.filtrarPorMarca(_marcaFilter);
    } else if (_modeloFilter.isNotEmpty) {
      return provider.filtrarPorModelo(_modeloFilter);
    } else {
      return provider.vehiculos;
    }
  }

  void _navigateToForm(BuildContext context, {Vehiculo? vehiculo}) {
    Navigator.pushNamed(
      context,
      AppRoutes.vehiculoForm,
      arguments: vehiculo,
    );
  }

  Future<void> _confirmarEliminar(BuildContext context, int idVehiculo) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: Constants.eliminar,
      message: Constants.eliminarVehiculo,
      confirmText: Constants.eliminar,
      cancelText: Constants.cancelar,
      isDestructiveAction: true,
    );

    if (confirmed == true) {
      if (mounted) {
        context.read<VehiculoProvider>().eliminar(idVehiculo);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehículo eliminado correctamente')),
        );
      }
    }
  }

  void _limpiarFiltros() {
    setState(() {
      _marcaFilter = '';
      _modeloFilter = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Constants.vehiculosTitle,
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Filtros
          VehiculoFilter(
            onMarcaChanged: (value) => setState(() => _marcaFilter = value),
            onModeloChanged: (value) => setState(() => _modeloFilter = value),
            onClear: _limpiarFiltros,
          ),
          
          // Lista de vehículos
          Expanded(
            child: Consumer<VehiculoProvider>(
              builder: (context, provider, child) {
                final vehiculos = _getFilteredList(provider);
                
                if (vehiculos.isEmpty) {
                  return EmptyState(
                    message: Constants.sinRegistros,
                    icon: Icons.directions_car,
                    actionLabel: Constants.agregarVehiculo,
                    onActionPressed: () => _navigateToForm(context),
                  );
                }
                
                return ListView.builder(
                  itemCount: vehiculos.length,
                  itemBuilder: (context, index) {
                    final vehiculo = vehiculos[index];
                    return VehiculoCard(
                      vehiculo: vehiculo,
                      onEdit: () => _navigateToForm(context, vehiculo: vehiculo),
                      onDelete: () => _confirmarEliminar(context, vehiculo.idVehiculo),
                    );
                  },
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
}