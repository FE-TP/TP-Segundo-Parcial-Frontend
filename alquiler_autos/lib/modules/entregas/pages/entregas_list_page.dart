import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/entrega_provider.dart';
import '../widgets/entrega_card.dart';
import 'entrega_form_page.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/theme/app_colors.dart';

class EntregasListPage extends StatefulWidget {
  const EntregasListPage({super.key});

  @override
  State<EntregasListPage> createState() => _EntregasListPageState();
}

class _EntregasListPageState extends State<EntregasListPage> {
  final _searchController = TextEditingController();
  String _selectedEstado = 'todos';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entregas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () => _mostrarEstadisticas(context),
            tooltip: 'Ver estadísticas',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomTextField(
                  controller: _searchController,
                  labelText: 'Buscar entregas',
                  hintText: 'Ingrese número, cliente o vehículo',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 8),
                _buildFiltroEstado(),
              ],
            ),
          ),
          Expanded(
            child: Consumer<EntregaProvider>(
              builder: (context, entregaProvider, child) {
                var entregas = entregaProvider.entregas;

                // Aplicar filtro por búsqueda si hay texto
                if (_searchController.text.isNotEmpty) {
                  entregas = entregaProvider.buscar(_searchController.text);
                }

                // Aplicar filtro por estado
                if (_selectedEstado != 'todos') {
                  entregas = entregas
                      .where((e) => e.estado.toLowerCase() == _selectedEstado)
                      .toList();
                }

                // Crear una lista mutable y ordenar por ID de forma descendente (más recientes primero)
                entregas = List.from(entregas)..sort((a, b) => b.idEntrega.compareTo(a.idEntrega));

                if (entregas.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.sentiment_dissatisfied,
                          size: 50,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isNotEmpty
                              ? 'No se encontraron entregas'
                              : 'No hay entregas registradas',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: entregas.length,
                  itemBuilder: (context, index) {
                    final entrega = entregas[index];
                    return EntregaCard(
                      entrega: entrega,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EntregaFormPage(entrega: entrega),
                        ),
                      ),
                      onDelete: () => _confirmarEliminar(context, entrega.idEntrega),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EntregaFormPage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('REGISTRAR ENTREGA'),
      ),
    );
  }

  Widget _buildFiltroEstado() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChipFiltro('Todos', 'todos'),
          const SizedBox(width: 8),
          _buildChipFiltro('Completadas', 'completada'),
          const SizedBox(width: 8),
          _buildChipFiltro('Pendientes', 'pendiente'),
          const SizedBox(width: 8),
          _buildChipFiltro('Canceladas', 'cancelada'),
        ],
      ),
    );
  }

  Widget _buildChipFiltro(String label, String estado) {
    final isSelected = _selectedEstado == estado;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      checkmarkColor: Colors.white,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
      ),
      onSelected: (selected) {
        setState(() {
          _selectedEstado = selected ? estado : 'todos';
        });
      },
    );
  }

  Future<void> _confirmarEliminar(BuildContext context, int idEntrega) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Está seguro de eliminar esta entrega?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'ELIMINAR',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!context.mounted) return;
      
      Provider.of<EntregaProvider>(context, listen: false)
          .eliminar(idEntrega);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entrega eliminada correctamente ✅'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _mostrarEstadisticas(BuildContext context) {
    final estadisticas =
        Provider.of<EntregaProvider>(context, listen: false).obtenerEstadisticas();

    final total = estadisticas.values.fold(0, (sum, count) => sum + count);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Estadísticas de Entregas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEstadisticaRow(
              'Completadas',
              estadisticas['completada'] ?? 0,
              total,
              Colors.green,
            ),
            const SizedBox(height: 8),
            _buildEstadisticaRow(
              'Pendientes',
              estadisticas['pendiente'] ?? 0,
              total,
              Colors.orange,
            ),
            const SizedBox(height: 8),
            _buildEstadisticaRow(
              'Canceladas',
              estadisticas['cancelada'] ?? 0,
              total,
              Colors.grey,
            ),
            const Divider(),
            Text(
              'Total de entregas: $total',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CERRAR'),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadisticaRow(
    String label,
    int count,
    int total,
    Color color,
  ) {
    final porcentaje = total > 0 ? (count / total * 100).toStringAsFixed(1) : '0';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.circle, size: 12, color: color),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
        Text('$count ($porcentaje%)'),
      ],
    );
  }
}