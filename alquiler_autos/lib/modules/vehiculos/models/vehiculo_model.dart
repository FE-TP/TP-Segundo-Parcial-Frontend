/// Modelo de vehículo para el sistema de alquiler
class Vehiculo {
  final int idVehiculo;
  String marca;
  String modelo;
  int anio;
  bool disponible;
  
  Vehiculo({
    required this.idVehiculo,
    required this.marca,
    required this.modelo,
    required this.anio,
    this.disponible = true,
  });
  
  /// Crea una copia del vehículo con valores actualizados
  Vehiculo copyWith({
    String? marca,
    String? modelo,
    int? anio,
    bool? disponible,
  }) {
    return Vehiculo(
      idVehiculo: this.idVehiculo,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      anio: anio ?? this.anio,
      disponible: disponible ?? this.disponible,
    );
  }
  
  /// Convierte el vehículo a un mapa para serialización
  Map<String, dynamic> toMap() {
    return {
      'idVehiculo': idVehiculo,
      'marca': marca,
      'modelo': modelo,
      'anio': anio,
      'disponible': disponible,
    };
  }
  
  /// Crea un vehículo desde un mapa (deserialización)
  factory Vehiculo.fromMap(Map<String, dynamic> map) {
    return Vehiculo(
      idVehiculo: map['idVehiculo'],
      marca: map['marca'],
      modelo: map['modelo'],
      anio: map['anio'],
      disponible: map['disponible'],
    );
  }
  
  @override
  String toString() {
    return '$marca $modelo ($anio)';
  }
}