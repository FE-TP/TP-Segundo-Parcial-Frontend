import 'package:flutter/material.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/constants.dart';

class VehiculoFilter extends StatefulWidget {
  final Function(String) onMarcaChanged;
  final Function(String) onModeloChanged;
  final VoidCallback onClear;

  const VehiculoFilter({
    super.key,
    required this.onMarcaChanged,
    required this.onModeloChanged,
    required this.onClear,
  });

  @override
  State<VehiculoFilter> createState() => _VehiculoFilterState();
}

class _VehiculoFilterState extends State<VehiculoFilter> {
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    super.dispose();
  }

  void _limpiarFiltros() {
    setState(() {
      _marcaController.clear();
      _modeloController.clear();
    });
    widget.onClear();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text(Constants.filtrar),
      leading: const Icon(Icons.filter_list),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextField(
                labelText: Constants.marcaLabel,
                hintText: 'Filtrar por marca',
                controller: _marcaController,
                onChanged: widget.onMarcaChanged,
                prefixIcon: const Icon(Icons.car_repair),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: Constants.modeloLabel,
                hintText: 'Filtrar por modelo',
                controller: _modeloController,
                onChanged: widget.onModeloChanged,
                prefixIcon: const Icon(Icons.directions_car),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: _limpiarFiltros,
                    icon: const Icon(Icons.clear),
                    label: const Text(Constants.limpiar),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}