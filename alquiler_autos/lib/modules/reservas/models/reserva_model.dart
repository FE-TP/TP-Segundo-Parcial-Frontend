/// Modelo de reserva para el sistema de alquiler
class Reserva {
  final int idReserva;
  int idCliente;
  int idVehiculo;
  DateTime fechaReserva;
  DateTime fechaInicio;
  DateTime fechaFin;
  String estado; // 'pendiente', 'confirmada', 'cancelada', 'finalizada'
  double? montoTotal;
  String? observaciones;

  // Datos relacionados (para mostrar en la UI)
  String? clienteNombre;
  String? vehiculoInfo;

  Reserva({
    required this.idReserva,
    required this.idCliente,
    required this.idVehiculo,
    required this.fechaReserva,
    required this.fechaInicio,
    required this.fechaFin,
    this.estado = 'pendiente',
    this.montoTotal,
    this.observaciones,
    this.clienteNombre,
    this.vehiculoInfo,
  });

  Reserva copyWith({
    int? idReserva,
    int? idCliente,
    int? idVehiculo,
    DateTime? fechaReserva,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? estado,
    double? montoTotal,
    String? observaciones,
    String? clienteNombre,
    String? vehiculoInfo,
  }) {
    return Reserva(
      idReserva: idReserva ?? this.idReserva,
      idCliente: idCliente ?? this.idCliente,
      idVehiculo: idVehiculo ?? this.idVehiculo,
      fechaReserva: fechaReserva ?? this.fechaReserva,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      estado: estado ?? this.estado,
      montoTotal: montoTotal ?? this.montoTotal,
      observaciones: observaciones ?? this.observaciones,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      vehiculoInfo: vehiculoInfo ?? this.vehiculoInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idReserva': idReserva,
      'idCliente': idCliente,
      'idVehiculo': idVehiculo,
      'fechaReserva': fechaReserva.toIso8601String(),
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin.toIso8601String(),
      'estado': estado,
      'montoTotal': montoTotal,
      'observaciones': observaciones,
      'clienteNombre': clienteNombre,
      'vehiculoInfo': vehiculoInfo,
    };
  }

  factory Reserva.fromMap(Map<String, dynamic> map) {
    return Reserva(
      idReserva: map['idReserva'],
      idCliente: map['idCliente'],
      idVehiculo: map['idVehiculo'],
      fechaReserva: DateTime.parse(map['fechaReserva']),
      fechaInicio: DateTime.parse(map['fechaInicio']),
      fechaFin: DateTime.parse(map['fechaFin']),
      estado: map['estado'],
      montoTotal: map['montoTotal']?.toDouble(),
      observaciones: map['observaciones'],
      clienteNombre: map['clienteNombre'],
      vehiculoInfo: map['vehiculoInfo'],
    );
  }

  int get diasReserva => fechaFin.difference(fechaInicio).inDays;

  bool get estaActiva => estado == 'confirmada' || estado == 'pendiente';
  bool get estaPendiente => estado == 'pendiente';
  bool get estaConfirmada => estado == 'confirmada';
  bool get estaCancelada => estado == 'cancelada';
  bool get estaFinalizada => estado == 'finalizada';

  @override
  String toString() {
    return 'Reserva #$idReserva - Cliente #$idCliente - Vehículo #$idVehiculo';
  }
}
