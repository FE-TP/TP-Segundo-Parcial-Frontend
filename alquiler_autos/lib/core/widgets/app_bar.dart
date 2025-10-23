import 'package:flutter/material.dart';

/// Widget personalizado para la barra de navegación superior de la aplicación
class CustomAppBar extends AppBar {
  CustomAppBar({
    super.key,
    required String title,
    super.actions,
  }) : super(
          title: Text(title),
          centerTitle: true,
          elevation: 2,
        );
}