import 'package:flutter/foundation.dart';
import '../models/entrega_model.dart';

class EntregaProvider extends ChangeNotifier {
  final List<Entrega> _entregas = [];
  int _nextId = 1;

  List<Entrega> get entregas => List.unmodifiable(_entregas);

  void agregar(Entrega entrega) {
    _entregas.add(entrega);
    _nextId++;
    notifyListeners();
  }

  void actualizar(Entrega entrega) {
    final index = _entregas.indexWhere((e) => e.idEntrega == entrega.idEntrega);
    if (index != -1) {
      _entregas[index] = entrega;
      notifyListeners();
    }
  }

  void eliminar(int id) {
    _entregas.removeWhere((e) => e.idEntrega == id);
    notifyListeners();
  }

  int get nextId => _nextId;
}
