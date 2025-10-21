import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importar proveedores
import 'modules/vehiculos/providers/vehiculo_provider.dart';

// Importar páginas
import 'modules/vehiculos/pages/vehiculos_list_page_new.dart';

/// Clase principal de la aplicación
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VehiculoProvider()),
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
        // Iniciar directamente en la página de vehículos
        home: const VehiculosListPage(),
      ),
    );
  }
}