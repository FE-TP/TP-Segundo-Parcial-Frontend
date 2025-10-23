import 'package:flutter/material.dart';

class TextStyles {
  // Estilos de título
  static const TextStyle headline1 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle headline2 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle headline3 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  );
  
  // Estilos de cuerpo
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
  );
  
  // Estilos de botón
  static const TextStyle button = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );
  
  // Otros estilos
  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.italic,
  );
}