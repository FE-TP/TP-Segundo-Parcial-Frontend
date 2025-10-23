import 'package:flutter/foundation.dart';
import '../models/vehiculo_model.dart';

/// Provider que gestiona la lista de vehículos disponibles
class VehiculoProvider extends ChangeNotifier {
  // Lista interna de vehículos
  final List<Vehiculo> _vehiculos = [];
  
  // ID autoincrementable para nuevos vehículos
  int _nextId = 1;
  
  // Datos de ejemplo para iniciar la aplicación
  VehiculoProvider() {
    // Agregar algunos vehículos de ejemplo
    _agregarVehiculosDePrueba();
  }
  
  // Getter para obtener una copia de la lista de vehículos
  List<Vehiculo> get vehiculos => List.unmodifiable(_vehiculos);
  
  // Obtener el siguiente ID disponible
  int get nextId => _nextId++;
  
  /// Agrega un nuevo vehículo a la lista
  void agregar(Vehiculo vehiculo) {
    _vehiculos.add(vehiculo);
    notifyListeners();
  }
  
  /// Actualiza un vehículo existente
  void actualizar(Vehiculo vehiculo) {
    final index = _vehiculos.indexWhere((v) => v.idVehiculo == vehiculo.idVehiculo);
    
    if (index != -1) {
      _vehiculos[index] = vehiculo;
      notifyListeners();
    }
  }
  
  /// Elimina un vehículo por su ID
  void eliminar(int id) {
    _vehiculos.removeWhere((vehiculo) => vehiculo.idVehiculo == id);
    notifyListeners();
  }
  
  /// Obtiene un vehículo por su ID
  Vehiculo? obtenerPorId(int id) {
    try {
      return _vehiculos.firstWhere((v) => v.idVehiculo == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Filtra vehículos por marca
  List<Vehiculo> filtrarPorMarca(String marca) {
    if (marca.isEmpty) return vehiculos;
    
    return _vehiculos.where(
      (v) => v.marca.toLowerCase().contains(marca.toLowerCase())
    ).toList();
  }
  
  /// Filtra vehículos por modelo
  List<Vehiculo> filtrarPorModelo(String modelo) {
    if (modelo.isEmpty) return vehiculos;
    
    return _vehiculos.where(
      (v) => v.modelo.toLowerCase().contains(modelo.toLowerCase())
    ).toList();
  }
  
  /// Filtra vehículos por disponibilidad
  List<Vehiculo> obtenerDisponibles() {
    return _vehiculos.where((v) => v.disponible).toList();
  }
  
  /// Cambia el estado de disponibilidad de un vehículo
  void cambiarDisponibilidad(int id, bool disponible) {
    final index = _vehiculos.indexWhere((v) => v.idVehiculo == id);
    
    if (index != -1) {
      _vehiculos[index].disponible = disponible;
      notifyListeners();
    }
  }
  
  /// Método privado para agregar vehículos de ejemplo
  void _agregarVehiculosDePrueba() {
    agregar(Vehiculo(
      idVehiculo: nextId,
      marca: 'Toyota',
      modelo: 'Corolla',
      anio: 2023,
    ));
    
    agregar(Vehiculo(
      idVehiculo: nextId,
      marca: 'Honda',
      modelo: 'Civic',
      anio: 2022,
    ));
    
    agregar(Vehiculo(
      idVehiculo: nextId,
      marca: 'Ford',
      modelo: 'Focus',
      anio: 2021,
    ));
    
    agregar(Vehiculo(
      idVehiculo: nextId,
      marca: 'Volkswagen',
      modelo: 'Golf',
      anio: 2023,
      disponible: false,
    ));
    
    agregar(Vehiculo(
      idVehiculo: nextId,
      marca: 'Toyota',
      modelo: 'Hilux',
      anio: 2024,
    ));
  }
}