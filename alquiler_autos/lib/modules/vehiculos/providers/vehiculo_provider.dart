import 'package:flutter/foundation.dart';
import '../models/vehiculo_model.dart';

/// Provider que gestiona la lista de vehículos disponibles
class VehiculoProvider with ChangeNotifier {
  // Lista interna de vehículos
  final List<Vehiculo> _vehiculos = [
    Vehiculo(
      idVehiculo: 1,
      marca: 'Toyota',
      modelo: 'Corolla',
      anio: 2020,
      disponible: false,
    ),
    Vehiculo(
      idVehiculo: 2,
      marca: 'Honda',
      modelo: 'Civic',
      anio: 2021,
      disponible: false,
    ),
    Vehiculo(
      idVehiculo: 3,
      marca: 'Ford',
      modelo: 'Focus',
      anio: 2019,
      disponible: false,
    ),
    Vehiculo(
      idVehiculo: 4,
      marca: 'Chevrolet',
      modelo: 'Cruze',
      anio: 2022,
      disponible: true,
    ),
    Vehiculo(
      idVehiculo: 5,
      marca: 'Volkswagen',
      modelo: 'Vento',
      anio: 2021,
      disponible: true,
    ),
  ];

  // ID autoincrementable para nuevos vehículos
  int _nextId = 6;

  // Getter para obtener una copia de la lista de vehículos
  List<Vehiculo> get vehiculos => List.unmodifiable(_vehiculos);

  // Obtener el siguiente ID disponible
  int get nextId => _nextId;

  /// Agrega un nuevo vehículo a la lista
  void agregar(Vehiculo vehiculo) {
    final nuevoVehiculo = vehiculo.copyWith(idVehiculo: _nextId++);
    _vehiculos.add(nuevoVehiculo);
    notifyListeners();
  }

  /// Actualiza un vehículo existente
  void actualizar(Vehiculo vehiculo) {
    final index = _vehiculos.indexWhere(
      (v) => v.idVehiculo == vehiculo.idVehiculo,
    );

    if (index != -1) {
      _vehiculos[index] = vehiculo;
      notifyListeners();
    }
  }

  /// Elimina un vehículo por su ID
  void eliminar(int idVehiculo) {
    _vehiculos.removeWhere((v) => v.idVehiculo == idVehiculo);
    notifyListeners();
  }

  /// Obtiene un vehículo por su ID
  Vehiculo? obtenerPorId(int idVehiculo) {
    try {
      return _vehiculos.firstWhere((v) => v.idVehiculo == idVehiculo);
    } catch (e) {
      return null;
    }
  }

  /// Actualiza la disponibilidad de un vehículo
  void actualizarDisponibilidad(int idVehiculo, bool disponible) {
    final index = _vehiculos.indexWhere((v) => v.idVehiculo == idVehiculo);
    if (index != -1) {
      _vehiculos[index].disponible = disponible;
      notifyListeners();
    }
  }

  /// Sincroniza la disponibilidad de los vehículos con las reservas activas
  void sincronizarConReservas(List<int> vehiculosReservados) {
    for (var vehiculo in _vehiculos) {
      final deberiaEstarReservado = vehiculosReservados.contains(
        vehiculo.idVehiculo,
      );
      if (vehiculo.disponible == deberiaEstarReservado) {
        // Si está disponible pero debería estar reservado, o viceversa
        vehiculo.disponible = !deberiaEstarReservado;
      }
    }
    notifyListeners();
  }
}
