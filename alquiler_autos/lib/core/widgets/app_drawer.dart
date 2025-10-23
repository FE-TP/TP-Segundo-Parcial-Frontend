import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.car_rental, size: 40, color: Colors.blue),
                ),
                SizedBox(height: 10),
                Text(
                  'Sistema de Alquiler',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Gestión Integral',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.home);
            },
          ),
          ListTile(
            leading: const Icon(Icons.car_rental),
            title: const Text('Vehículos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.vehiculos);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Clientes'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.clientes);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Reservas'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.reservas);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delivery_dining),
            title: const Text('Entregas'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.entregas);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Estadísticas'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.estadisticas);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              Navigator.pop(context);
              // Implementar navegación a configuración
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Acerca de'),
            onTap: () {
              Navigator.pop(context);
              // Implementar diálogo de acerca de
              showAboutDialog(
                context: context,
                applicationName: 'Sistema de Alquiler de Autos',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2023 - Todos los derechos reservados',
                children: [
                  const SizedBox(height: 10),
                  const Text('Aplicación desarrollada como parte del TP Segundo Parcial Frontend.'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}