import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_text_field.dart';

class ClienteFilter extends StatelessWidget {
  final TextEditingController nombreController;
  final TextEditingController documentoController;
  final ValueChanged<String>? onNombreChanged;
  final ValueChanged<String>? onDocumentoChanged;
  final VoidCallback onClearFilters;

  const ClienteFilter({
    super.key,
    required this.nombreController,
    required this.documentoController,
    required this.onClearFilters,
    this.onNombreChanged,
    this.onDocumentoChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tieneFiltros = nombreController.text.isNotEmpty ||
        documentoController.text.isNotEmpty;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                labelText: 'Buscar por nombre o apellido',
                hintText: 'Ej.: Juan Pérez',
                controller: nombreController,
                prefixIcon: const Icon(Icons.search),
                textCapitalization: TextCapitalization.words,
                onChanged: onNombreChanged,
              ),
            ),
            if (tieneFiltros)
              IconButton(
                tooltip: 'Limpiar filtros',
                onPressed: onClearFilters,
                icon: const Icon(Icons.clear),
              ),
          ],
        ),
        const SizedBox(height: 8),
        CustomTextField(
          labelText: 'Filtrar por documento',
          hintText: 'Solo números',
          controller: documentoController,
          prefixIcon: const Icon(Icons.badge),
          keyboardType: TextInputType.number,
          onChanged: onDocumentoChanged,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 20),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.info.withValues(alpha: 51)),
          ),
          child: const Row(
            children: [
              Icon(Icons.lightbulb, color: AppColors.info, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tip: combina nombre y documento para búsquedas más precisas.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
