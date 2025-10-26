import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../providers/estadisticas_provider.dart';
import '../widgets/stat_card.dart';

class EstadisticasPage extends StatelessWidget {
  const EstadisticasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
        centerTitle: true,
      ),
      body: Consumer<EstadisticasProvider>(
        builder: (context, estadisticas, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título de la sección
                const Text(
                  'Resumen General',
                  style: TextStyles.headline1,
                ),
                const SizedBox(height: 8),
                Text(
                  'Vista general del sistema de alquiler',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Estadísticas principales
                StatCard(
                  icon: Icons.assignment_turned_in,
                  title: 'Reservas Activas',
                  value: '${estadisticas.totalReservasActivas}',
                  subtitle: 'Reservas confirmadas o pendientes',
                  color: AppColors.success,
                ),
                
                const SizedBox(height: 16),
                
                StatCard(
                  icon: Icons.directions_car,
                  title: 'Vehículos Disponibles',
                  value: '${estadisticas.cantidadVehiculosDisponibles}',
                  subtitle: 'De ${estadisticas.totalVehiculos} vehículos en total',
                  color: AppColors.primary,
                ),
                
                const SizedBox(height: 16),
                
                // Cliente con más reservas
                _buildClienteTopCard(estadisticas),
                
                const SizedBox(height: 32),
                
                // Sección de estadísticas adicionales
                const Text(
                  'Detalles de Reservas',
                  style: TextStyles.headline2,
                ),
                const SizedBox(height: 16),
                
                // Grid de estadísticas secundarias
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    _buildSmallStatCard(
                      icon: Icons.check_circle,
                      title: 'Confirmadas',
                      value: '${estadisticas.reservasConfirmadas}',
                      color: Colors.green,
                    ),
                    _buildSmallStatCard(
                      icon: Icons.pending,
                      title: 'Pendientes',
                      value: '${estadisticas.reservasPendientes}',
                      color: AppColors.warning,
                    ),
                    _buildSmallStatCard(
                      icon: Icons.done_all,
                      title: 'Finalizadas',
                      value: '${estadisticas.reservasFinalizadas}',
                      color: AppColors.info,
                    ),
                    _buildSmallStatCard(
                      icon: Icons.cancel,
                      title: 'Canceladas',
                      value: '${estadisticas.reservasCanceladas}',
                      color: AppColors.error,
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Totales del sistema
                const Text(
                  'Totales del Sistema',
                  style: TextStyles.headline2,
                ),
                const SizedBox(height: 16),
                
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildTotalRow(
                          Icons.directions_car,
                          'Total Vehículos',
                          estadisticas.totalVehiculos,
                          AppColors.primary,
                        ),
                        const Divider(height: 24),
                        _buildTotalRow(
                          Icons.people,
                          'Total Clientes',
                          estadisticas.totalClientes,
                          AppColors.accent,
                        ),
                        const Divider(height: 24),
                        _buildTotalRow(
                          Icons.calendar_today,
                          'Total Reservas',
                          estadisticas.totalReservas,
                          Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildClienteTopCard(EstadisticasProvider estadisticas) {
    final clienteTop = estadisticas.clienteConMasReservas;
    
    if (clienteTop == null) {
      return StatCard(
        icon: Icons.person_outline,
        title: 'Cliente Destacado',
        value: '-',
        subtitle: 'No hay datos disponibles',
        color: AppColors.accent,
      );
    }
    
    return StatCard(
      icon: Icons.person,
      title: 'Cliente con Más Reservas',
      value: '${clienteTop['cantidadReservas']}',
      subtitle: clienteTop['nombre'],
      color: AppColors.accent,
    );
  }

  Widget _buildSmallStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyles.headline1.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(IconData icon, String label, int value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: TextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          '$value',
          style: TextStyles.headline2.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}