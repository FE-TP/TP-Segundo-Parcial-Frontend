import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cliente_provider.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/app_bar.dart';
import '../models/cliente_model.dart';

class ClienteListaPage extends StatefulWidget {
  static const String route = '/clientes';

  const ClienteListaPage({super.key});

  @override
  State<ClienteListaPage> createState() => _ClienteListaPageState();
}

class _ClienteListaPageState extends State<ClienteListaPage> {
  String _busqueda = '';
  bool _filtrarPorDocumento = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Clientes'),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Consumer<ClienteProvider>(
              builder: (context, provider, child) {
                final clientes = _filtrarPorDocumento 
                    ? provider.filtrarPorDocumento(_busqueda)
                    : provider.filtrarPorNombreCompleto(_busqueda);
                
                if (clientes.isEmpty) {
                  return const Center(
                    child: Text('No hay clientes disponibles'),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: clientes.length,
                  itemBuilder: (context, index) => _buildClienteItem(clientes[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showClienteForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _busqueda = value;
                });
              },
              decoration: InputDecoration(
                hintText: _filtrarPorDocumento 
                    ? 'Buscar por documento...'
                    : 'Buscar por nombre...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              setState(() {
                _filtrarPorDocumento = !_filtrarPorDocumento;
              });
            },
            icon: Icon(
              _filtrarPorDocumento ? Icons.numbers : Icons.person,
              color: Theme.of(context).primaryColor,
            ),
            tooltip: _filtrarPorDocumento 
                ? 'Cambiar a búsqueda por nombre'
                : 'Cambiar a búsqueda por documento',
          ),
        ],
      ),
    );
  }

  Widget _buildClienteItem(Cliente cliente) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            cliente.nombre.substring(0, 1) + cliente.apellido.substring(0, 1),
          ),
        ),
        title: Text('${cliente.nombre} ${cliente.apellido}'),
        subtitle: Text('Documento: ${cliente.numeroDocumento}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showClienteForm(context, cliente: cliente),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmarEliminacion(context, cliente),
            ),
          ],
        ),
      ),
    );
  }

  void _showClienteForm(BuildContext context, {Cliente? cliente}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ClienteFormPage(cliente: cliente),
      ),
    );
  }

  void _confirmarEliminacion(BuildContext context, Cliente cliente) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Cliente'),
        content: Text('¿Está seguro que desea eliminar a ${cliente.nombre} ${cliente.apellido}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ClienteProvider>(context, listen: false)
                  .eliminar(cliente.idCliente);
              Navigator.of(context).pop();
            },
            child: const Text('ELIMINAR'),
          ),
        ],
      ),
    );
  }
}