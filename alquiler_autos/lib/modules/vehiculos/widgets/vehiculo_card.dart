import 'package:flutter/material.dart';
import '../models/vehiculo_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/custom_button.dart';

class VehiculoCard extends StatelessWidget {
  final Vehiculo vehiculo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  
  const VehiculoCard({
    super.key,
    required this.vehiculo,
    required this.onEdit,
    required this.onDelete,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${vehiculo.marca} ${vehiculo.modelo}',
                    style: TextStyles.headline3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildDisponibilidadChip(),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Año: ${vehiculo.anio}',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  text: 'Editar',
                  onPressed: onEdit,
                  type: CustomButtonType.outline,
                  icon: Icons.edit,
                ),
                const SizedBox(width: 8),
                CustomButton(
                  text: 'Eliminar',
                  onPressed: onDelete,
                  type: CustomButtonType.text,
                  icon: Icons.delete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDisponibilidadChip() {
    return Chip(
      label: Text(
        vehiculo.disponible ? 'Disponible' : 'No disponible',
        style: TextStyle(
          color: vehiculo.disponible ? AppColors.success : AppColors.error,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      backgroundColor: vehiculo.disponible 
          ? AppColors.success.withOpacity(0.1)
          : AppColors.error.withOpacity(0.1),
      side: BorderSide(
        color: vehiculo.disponible ? AppColors.success : AppColors.error,
        width: 1,
      ),
    );
  }
}