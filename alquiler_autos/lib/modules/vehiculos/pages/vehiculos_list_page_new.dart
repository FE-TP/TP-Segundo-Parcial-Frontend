import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vehiculo_provider.dart';
import '../models/vehiculo_model.dart';
import 'vehiculo_form_page_new.dart';

class VehiculosListPage extends StatefulWidget {
  const VehiculosListPage({super.key});

  @override
  State<VehiculosListPage> createState() => _VehiculosListPageState();
}

class _VehiculosListPageState extends State<VehiculosListPage> {
  String _marcaFilter = '';
  String _modeloFilter = '';

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
          Expanded(
            child: Consumer<VehiculoProvider>(
              builder: (context, provider, child) {
                final vehiculos = _getFilteredVehiculos(provider);
                
                if (vehiculos.isEmpty) {
                  return const Center(
                    child: Text('No hay vehículos disponibles'),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: vehiculos.length,
                  itemBuilder: (context, index) => _buildVehiculoItem(context, vehiculos[index]),
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
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Filtrar por marca...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _marcaFilter = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Filtrar por modelo...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _modeloFilter = value;
                    });
                  },
                ),
              ),
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
    if (_marcaFilter.isEmpty && _modeloFilter.isEmpty) {
      return provider.vehiculos;
    }
    
    var lista = provider.vehiculos;
    
    if (_marcaFilter.isNotEmpty) {
      lista = lista.where((v) => 
        v.marca.toLowerCase().contains(_marcaFilter.toLowerCase())
      ).toList();
    }
    
    if (_modeloFilter.isNotEmpty) {
      lista = lista.where((v) => 
        v.modelo.toLowerCase().contains(_modeloFilter.toLowerCase())
      ).toList();
    }
    
    return lista;
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