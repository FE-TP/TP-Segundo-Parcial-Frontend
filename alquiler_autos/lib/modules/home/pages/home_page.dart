import 'package:flutter/material.dart';
import '../../../core/utils/constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../widgets/menu_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Sistema de Gestión',
                  style: TextStyles.headline1,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Grid de módulos
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                MenuCard(
                  title: Constants.vehiculosTitle,
                  icon: Icons.directions_car,
                  color: AppColors.primary,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.vehiculos),
                ),
                MenuCard(
                  title: Constants.clientesTitle,
                  icon: Icons.people,
                  color: AppColors.accent,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.clientes),
                ),
                MenuCard(
                  title: Constants.reservasTitle,
                  icon: Icons.calendar_today,
                  color: Colors.green,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.reservas),
                ),
                MenuCard(
                  title: Constants.entregasTitle,
                  icon: Icons.assignment_return,
                  color: Colors.purple,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.entregas),
                ),
                MenuCard(
                  title: Constants.estadisticasTitle,
                  icon: Icons.bar_chart,
                  color: Colors.teal,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.estadisticas),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
}