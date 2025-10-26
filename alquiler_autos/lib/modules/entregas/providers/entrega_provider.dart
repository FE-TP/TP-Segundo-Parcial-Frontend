import 'package:flutter/foundation.dart';
import '../models/entrega_model.dart';
import '../../reservas/providers/reserva_provider.dart';
import '../../vehiculos/providers/vehiculo_provider.dart';

/// Provider que maneja la lógica de negocio para las entregas de vehículos
class EntregaProvider extends ChangeNotifier {
  final List<Entrega> _entregas = [];
  int _nextId = 1;

  /// Getter para obtener la lista de entregas de manera inmutable
  List<Entrega> get entregas => List.unmodifiable(_entregas);

  /// Obtiene una entrega por su ID
  Entrega? obtenerPorId(int id) {
    try {
      return _entregas.firstWhere((e) => e.idEntrega == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene las entregas asociadas a una reserva
  List<Entrega> obtenerPorReserva(int idReserva) {
    return _entregas.where((e) => e.idReserva == idReserva).toList();
  }

  /// Agrega una nueva entrega y actualiza el estado del vehículo y la reserva
  void agregar(
    Entrega entrega,
    ReservaProvider reservaProvider,
    VehiculoProvider vehiculoProvider,
  ) {
    // Asignar ID único
    final nuevaEntrega = entrega.copyWith(idEntrega: _nextId);
    _entregas.add(nuevaEntrega);
    _nextId++;

    // Obtener la reserva asociada
    final reserva = reservaProvider.obtenerPorId(entrega.idReserva);
    if (reserva != null) {
      // Marcar la reserva como finalizada
      reservaProvider.cambiarEstado(reserva.idReserva, 'finalizada');

      // Verificar si el vehículo puede marcarse como disponible
      final reservasActivas = reservaProvider.obtenerReservasActivasPorVehiculo(
        reserva.idVehiculo,
      );

      // Si no hay otras reservas activas, marcar el vehículo como disponible
      if (reservasActivas.isEmpty) {
        vehiculoProvider.actualizarDisponibilidad(reserva.idVehiculo, true);
      }
    }

    notifyListeners();
  }

  /// Actualiza una entrega existente
  void actualizar(Entrega entrega) {
    final index = _entregas.indexWhere((e) => e.idEntrega == entrega.idEntrega);
    if (index != -1) {
      _entregas[index] = entrega;
      notifyListeners();
    }
  }

  /// Elimina una entrega por su ID
  void eliminar(int id) {
    _entregas.removeWhere((e) => e.idEntrega == id);
    notifyListeners();
  }

  /// Busca entregas por texto en cliente o vehículo
  List<Entrega> buscar(String query) {
    if (query.isEmpty) return entregas;
    
    final queryLower = query.toLowerCase();
    return _entregas.where((e) =>
        e.idEntrega.toString().contains(queryLower) ||
        e.idReserva.toString().contains(queryLower) ||
        e.estado.toLowerCase().contains(queryLower) ||
        (e.clienteNombre?.toLowerCase().contains(queryLower) ?? false) ||
        (e.vehiculoInfo?.toLowerCase().contains(queryLower) ?? false) ||
        (e.observaciones?.toLowerCase().contains(queryLower) ?? false)).toList();
  }

  /// Filtra las entregas por estado
  List<Entrega> filtrarPorEstado(String estado) {
    return _entregas.where((e) => e.estado.toLowerCase() == estado.toLowerCase()).toList();
  }

  /// Obtiene la cantidad de entregas por estado
  Map<String, int> obtenerEstadisticas() {
    final estadisticas = <String, int>{
      'completada': 0,
      'pendiente': 0,
      'cancelada': 0,
    };

    for (final entrega in _entregas) {
      estadisticas[entrega.estado] = (estadisticas[entrega.estado] ?? 0) + 1;
    }

    return estadisticas;
  }
}