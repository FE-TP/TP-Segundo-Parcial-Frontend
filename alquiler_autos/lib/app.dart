import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importar proveedores
import 'modules/vehiculos/providers/vehiculo_provider.dart';
import 'modules/reservas/providers/reserva_provider.dart';

// Importar modelos
import 'modules/vehiculos/models/vehiculo_model.dart';
import 'modules/reservas/models/reserva_model.dart';

// Importar páginas
import 'modules/vehiculos/pages/vehiculos_list_page.dart';
import 'modules/vehiculos/pages/vehiculo_form_page.dart';
import 'modules/home/pages/home_page.dart';
import 'modules/clientes/pages/clientes_list_page.dart';
import 'modules/reservas/pages/reservas_list_page.dart';
import 'modules/reservas/pages/reserva_form_page.dart';
import 'modules/entregas/pages/entregas_list_page.dart';
import 'modules/estadisticas/pages/estadisticas_page.dart';

// Importar rutas
import 'core/routes/app_routes.dart';

/// Clase principal de la aplicación
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VehiculoProvider()),
        ChangeNotifierProvider(create: (_) => ReservaProvider()),
        // Aquí se pueden agregar más providers a medida que se desarrollen los otros módulos
      ],
      child: MaterialApp(
        title: 'Sistema de Alquiler de Autos',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (context) => const HomePage(),
          AppRoutes.vehiculos: (context) => const VehiculosListPage(),
          AppRoutes.clientes: (context) => const ClientesListPage(),
          AppRoutes.reservas: (context) => const ReservasListPage(),
          AppRoutes.entregas: (context) => const EntregasListPage(),
          AppRoutes.estadisticas: (context) => const EstadisticasPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.vehiculoForm) {
            final vehiculo = settings.arguments as Vehiculo?;
            return MaterialPageRoute(
              builder: (context) => VehiculoFormPage(vehiculo: vehiculo),
            );
          }
          if (settings.name == AppRoutes.reservaForm) {
            final reserva = settings.arguments as Reserva?;
            return MaterialPageRoute(
              builder: (context) => ReservaFormPage(reserva: reserva),
            );
          }
          return null;
        },
      ),
    );
  }
}