import 'package:flutter/material.dart';

/// Widget personalizado para la barra de navegación superior de la aplicación
class CustomAppBar extends AppBar {
  CustomAppBar({
    super.key,
    required String title,
    List<Widget>? actions,
  }) : super(
          title: Text(title),
          centerTitle: true,
          actions: actions,
          elevation: 2,
        );
}