import 'package:flutter/material.dart';
import '../../modules/entregas/pages/entregas_list_page.dart';
import '../../modules/entregas/pages/entrega_form_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
        '/entregas': (context) => const EntregasListPage(),
        '/entregas/nueva': (context) => const EntregaFormPage(),
      };
}
