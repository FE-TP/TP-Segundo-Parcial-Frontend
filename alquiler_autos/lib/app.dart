import 'package:flutter/material.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alquiler de Autos',
      theme: AppTheme.lightTheme,
      routes: AppRoutes.routes,
      initialRoute: '/entregas',
    );
  }
}
