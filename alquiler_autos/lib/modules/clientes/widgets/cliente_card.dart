import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../models/cliente_model.dart';

class ClienteCard extends StatelessWidget {
  final Cliente cliente;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool tieneReservasActivas;
  final int reservasActivas;
  final VoidCallback? onTap;

  const ClienteCard({
    super.key,
    required this.cliente,
    required this.onEdit,
    required this.onDelete,
    this.tieneReservasActivas = false,
    this.reservasActivas = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iniciales = _obtenerIniciales(cliente);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap ?? onEdit,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 38),
                    foregroundColor: AppColors.primary,
                    child: Text(iniciales),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${cliente.nombre} ${cliente.apellido}',
                          style: TextStyles.headline3,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Documento: ${cliente.numeroDocumento}',
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (tieneReservasActivas) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.warning.withValues(alpha: 128),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.event_available,
                                  size: 16,
                                  color: Colors.black87,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  reservasActivas == 1
                                      ? '1 reserva activa'
                                      : '$reservasActivas reservas activas',
                                  style: TextStyles.bodySmall.copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'editar') {
                        onEdit();
                      } else if (value == 'eliminar') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'editar',
                        child: Text('Editar'),
                      ),
                      PopupMenuItem(
                        value: 'eliminar',
                        child: Text('Eliminar'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _obtenerIniciales(Cliente cliente) {
    final nombreInicial = cliente.nombre.isNotEmpty ? cliente.nombre[0] : '';
    final apellidoInicial = cliente.apellido.isNotEmpty ? cliente.apellido[0] : '';
    return (nombreInicial + apellidoInicial).toUpperCase();
  }
}
