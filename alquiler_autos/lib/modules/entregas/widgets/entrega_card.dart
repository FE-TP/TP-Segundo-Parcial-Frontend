import 'package:flutter/material.dart';
import '../models/entrega_model.dart';

/// Widget que muestra la información de una entrega en forma de tarjeta
class EntregaCard extends StatelessWidget {
  final Entrega entrega;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const EntregaCard({
    super.key,
    required this.entrega,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Entrega #${entrega.idEntrega}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: onDelete,
                      tooltip: 'Eliminar entrega',
                    ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Estado: ${entrega.estado}',
                    style: TextStyle(
                      color: entrega.estado == 'completada'
                          ? Colors.green
                          : entrega.estado == 'pendiente'
                              ? Colors.orange
                              : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    entrega.estado == 'completada'
                        ? Icons.check_circle
                        : entrega.estado == 'pendiente'
                            ? Icons.pending
                            : Icons.cancel,
                    color: entrega.estado == 'completada'
                        ? Colors.green
                        : entrega.estado == 'pendiente'
                            ? Colors.orange
                            : Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildInfoRow('🗓️ Fecha:', entrega.fechaEntrega.toLocal().toString().split(' ')[0]),
              _buildInfoRow('🚘 Vehículo:', entrega.vehiculoInfo ?? 'No disponible'),
              _buildInfoRow('👤 Cliente:', entrega.clienteNombre ?? 'No disponible'),
              if (entrega.kilometrajeFinal != null)
                _buildInfoRow('📍 Kilometraje:', '${entrega.kilometrajeFinal} km'),
              if (entrega.observaciones?.isNotEmpty ?? false)
                _buildInfoRow('📝 Observaciones:', entrega.observaciones!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}