/// Modelo de reserva para el sistema de alquiler
class Reserva {
  final int idReserva;
  final int idCliente;
  final int idVehiculo;
  DateTime fechaInicio;
  DateTime fechaFin;
  bool activa;

  Reserva({
    required this.idReserva,
    required this.idCliente,
    required this.idVehiculo,
    required this.fechaInicio,
    required this.fechaFin,
    this.activa = true,
  });
  
  /// Crea una copia de la reserva con valores actualizados
  Reserva copyWith({
    DateTime? fechaInicio,
    DateTime? fechaFin,
    bool? activa,
  }) {
    return Reserva(
      idReserva: this.idReserva,
      idCliente: this.idCliente,
      idVehiculo: this.idVehiculo,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      activa: activa ?? this.activa,
    );
  }
  
  /// Convierte la reserva a un mapa para serialización
  Map<String, dynamic> toMap() {
    return {
      'idReserva': idReserva,
      'idCliente': idCliente,
      'idVehiculo': idVehiculo,
      'fechaInicio': fechaInicio.millisecondsSinceEpoch,
      'fechaFin': fechaFin.millisecondsSinceEpoch,
      'activa': activa,
    };
  }
  
  /// Crea una reserva desde un mapa (deserialización)
  factory Reserva.fromMap(Map<String, dynamic> map) {
    return Reserva(
      idReserva: map['idReserva'],
      idCliente: map['idCliente'],
      idVehiculo: map['idVehiculo'],
      fechaInicio: DateTime.fromMillisecondsSinceEpoch(map['fechaInicio']),
      fechaFin: DateTime.fromMillisecondsSinceEpoch(map['fechaFin']),
      activa: map['activa'],
    );
  }
}