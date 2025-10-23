import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vehiculo_provider.dart';
import '../models/vehiculo_model.dart';
import 'vehiculo_form_page.dart';

class VehiculosListPage extends StatefulWidget {
  const VehiculosListPage({super.key});

  @override
  State<VehiculosListPage> createState() => _VehiculosListPageState();
}

class _VehiculosListPageState extends State<VehiculosListPage> {
  String _searchQuery = '';
  bool _showOnlyAvailable = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehículos'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Sugerencia: Puedes buscar por marca, modelo o año y usar el filtro de disponibilidad',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Consumer<VehiculoProvider>(
              builder: (context, provider, child) {
                final vehiculos = _getFilteredVehiculos(provider);
                final totalVehiculos = provider.vehiculos.length;
                
                if (vehiculos.isEmpty && (_searchQuery.isNotEmpty || _showOnlyAvailable)) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 48, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _showOnlyAvailable && _searchQuery.isEmpty
                            ? 'No hay vehículos disponibles en este momento'
                            : 'No se encontraron vehículos que coincidan con los filtros',
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
                            if (_showOnlyAvailable)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showOnlyAvailable = false;
                                  });
                                },
                                child: const Text('Mostrar todos'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (vehiculos.isEmpty) {
                  return const Center(
                    child: Text('No hay vehículos disponibles'),
                  );
                }
                
                return Column(
                  children: [
                    if (_searchQuery.isNotEmpty || _showOnlyAvailable)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Mostrando ${vehiculos.length} de $totalVehiculos vehículos' +
                          (_showOnlyAvailable ? ' (solo disponibles)' : ''),
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: vehiculos.length,
                        itemBuilder: (context, index) => _buildVehiculoItem(context, vehiculos[index]),
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
              hintText: 'Buscar por marca, modelo o año',
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
          Row(
            children: [
              Checkbox(
                value: _showOnlyAvailable,
                onChanged: (value) {
                  setState(() {
                    _showOnlyAvailable = value ?? false;
                  });
                },
              ),
              const Text('Mostrar solo vehículos disponibles'),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildVehiculoItem(BuildContext context, Vehiculo vehiculo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: vehiculo.disponible ? Colors.green : Colors.red,
          child: const Icon(
            Icons.directions_car,
            color: Colors.white,
          ),
        ),
        title: Text('${vehiculo.marca} ${vehiculo.modelo}'),
        subtitle: Text('Año: ${vehiculo.anio} | ${vehiculo.disponible ? "Disponible" : "No disponible"}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _navigateToForm(context, vehiculo: vehiculo),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmarEliminar(context, vehiculo.idVehiculo),
            ),
          ],
        ),
      ),
    );
  }

  List<Vehiculo> _getFilteredVehiculos(VehiculoProvider provider) {
    var vehiculos = provider.vehiculos;
    
    // Aplicar filtro de disponibilidad
    if (_showOnlyAvailable) {
      vehiculos = vehiculos.where((v) => v.disponible).toList();
    }
    
    // Aplicar filtro de texto
    if (_searchQuery.isEmpty) {
      return vehiculos;
    }
    
    final query = _searchQuery.toLowerCase();
    return vehiculos.where((v) => 
      v.marca.toLowerCase().contains(query) || 
      v.modelo.toLowerCase().contains(query) ||
      v.anio.toString().contains(query)
    ).toList();
  }

  void _navigateToForm(BuildContext context, {Vehiculo? vehiculo}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehiculoFormPage(vehiculo: vehiculo),
      ),
    );
  }

  Future<void> _confirmarEliminar(BuildContext context, int idVehiculo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar'),
        content: const Text('¿Está seguro que desea eliminar este vehículo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ELIMINAR'),
          ),
        ],
      ),
    ) ?? false;
    
    if (confirmed) {
      if (!context.mounted) return;
      
      final provider = Provider.of<VehiculoProvider>(context, listen: false);
      provider.eliminar(idVehiculo);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vehículo eliminado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}