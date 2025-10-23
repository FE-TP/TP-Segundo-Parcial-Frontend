import 'package:flutter/foundation.dart';
import '../models/reserva_model.dart';
import '../models/cliente_temp.dart';

class ReservaProvider with ChangeNotifier {
  final List<Reserva> _reservas = [
    Reserva(
      idReserva: 1,
      idCliente: 1,
      idVehiculo: 1,
      fechaReserva: DateTime.now().subtract(const Duration(days: 2)),
      fechaInicio: DateTime.now().add(const Duration(days: 1)),
      fechaFin: DateTime.now().add(const Duration(days: 5)),
      estado: 'confirmada',
      montoTotal: 25000.0,
      clienteNombre: ClientesData.obtenerPorId(1)?.nombre,
      vehiculoInfo: 'Toyota Corolla 2020',
    ),
    Reserva(
      idReserva: 2,
      idCliente: 2,
      idVehiculo: 2,
      fechaReserva: DateTime.now().subtract(const Duration(days: 1)),
      fechaInicio: DateTime.now().add(const Duration(days: 3)),
      fechaFin: DateTime.now().add(const Duration(days: 7)),
      estado: 'pendiente',
      montoTotal: 18000.0,
      clienteNombre: ClientesData.obtenerPorId(2)?.nombre,
      vehiculoInfo: 'Honda Civic 2021',
    ),
    Reserva(
      idReserva: 3,
      idCliente: 3,
      idVehiculo: 3,
      fechaReserva: DateTime.now().subtract(const Duration(days: 5)),
      fechaInicio: DateTime.now().subtract(const Duration(days: 2)),
      fechaFin: DateTime.now().add(const Duration(days: 2)),
      estado: 'confirmada',
      montoTotal: 32000.0,
      clienteNombre: ClientesData.obtenerPorId(3)?.nombre,
      vehiculoInfo: 'Ford Focus 2019',
    ),
  ];

  int _nextId = 4;

  List<Reserva> get reservas => List.unmodifiable(_reservas);
  int get nextId => _nextId;

  /// Verifica si un vehículo está reservado (tiene reservas activas)
  bool vehiculoEstaReservado(int idVehiculo) {
    return _reservas.any(
      (r) =>
          r.idVehiculo == idVehiculo &&
          (r.estado == 'confirmada' || r.estado == 'pendiente'),
    );
  }

  /// Obtiene los IDs de vehículos que están reservados
  List<int> obtenerVehiculosReservados() {
    return _reservas
        .where((r) => r.estado == 'confirmada' || r.estado == 'pendiente')
        .map((r) => r.idVehiculo)
        .toSet()
        .toList();
  }

  void agregar(Reserva reserva) {
    final nuevaReserva = reserva.copyWith(idReserva: _nextId++);
    _reservas.add(nuevaReserva);
    notifyListeners();
  }

  void actualizar(Reserva reserva) {
    final index = _reservas.indexWhere((r) => r.idReserva == reserva.idReserva);
    if (index != -1) {
      _reservas[index] = reserva;
      notifyListeners();
    }
  }

  void eliminar(int idReserva) {
    _reservas.removeWhere((r) => r.idReserva == idReserva);
    notifyListeners();
  }

  void cambiarEstado(int idReserva, String nuevoEstado) {
    final index = _reservas.indexWhere((r) => r.idReserva == idReserva);
    if (index != -1) {
      _reservas[index].estado = nuevoEstado;
      notifyListeners();
    }
  }

  Reserva? obtenerPorId(int idReserva) {
    try {
      return _reservas.firstWhere((r) => r.idReserva == idReserva);
    } catch (e) {
      return null;
    }
  }

  List<Reserva> obtenerPorCliente(int idCliente) {
    return _reservas.where((r) => r.idCliente == idCliente).toList();
  }

  List<Reserva> obtenerPorVehiculo(int idVehiculo) {
    return _reservas.where((r) => r.idVehiculo == idVehiculo).toList();
  }

  List<Reserva> obtenerPorEstado(String estado) {
    return _reservas.where((r) => r.estado == estado).toList();
  }

  /// Obtiene las reservas activas (confirmadas o pendientes) de un vehículo
  List<Reserva> obtenerReservasActivasPorVehiculo(int idVehiculo) {
    return _reservas
        .where(
          (r) =>
              r.idVehiculo == idVehiculo &&
              (r.estado == 'confirmada' || r.estado == 'pendiente'),
        )
        .toList();
  }
}
