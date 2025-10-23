import 'package:flutter/foundation.dart';

/// Modelo que representa una entrega de vehículo
class Entrega {
  /// ID único de la entrega
  final int idEntrega;

  /// ID de la reserva asociada a esta entrega
  final int idReserva;

  /// ID del vehículo asociado a esta entrega
  final int idVehiculo;

  /// Fecha real de la entrega del vehículo
  final DateTime fechaEntrega;

  /// Kilometraje final del vehículo al momento de la entrega
  final double? kilometrajeFinal;

  /// Observaciones o comentarios sobre la entrega
  final String? observaciones;

  /// Nombre del cliente (para mostrar en la lista)
  final String? clienteNombre;

  /// Información del vehículo (para mostrar en la lista)
  final String? vehiculoInfo;

  /// Estado de la entrega ('completada', 'pendiente', 'cancelada')
  final String estado;

  /// Constructor
  Entrega({
    required this.idEntrega,
    required this.idReserva,
    required this.idVehiculo,
    required this.fechaEntrega,
    this.kilometrajeFinal,
    this.observaciones,
    this.clienteNombre,
    this.vehiculoInfo,
    this.estado = 'completada',
  });

  /// Crea una copia de la entrega con campos actualizados
  Entrega copyWith({
    int? idEntrega,
    int? idReserva,
    int? idVehiculo,
    DateTime? fechaEntrega,
    double? kilometrajeFinal,
    String? observaciones,
    String? clienteNombre,
    String? vehiculoInfo,
    String? estado,
  }) {
    return Entrega(
      idEntrega: idEntrega ?? this.idEntrega,
      idReserva: idReserva ?? this.idReserva,
      idVehiculo: idVehiculo ?? this.idVehiculo,
      fechaEntrega: fechaEntrega ?? this.fechaEntrega,
      kilometrajeFinal: kilometrajeFinal ?? this.kilometrajeFinal,
      observaciones: observaciones ?? this.observaciones,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      vehiculoInfo: vehiculoInfo ?? this.vehiculoInfo,
      estado: estado ?? this.estado,
    );
  }

  /// Convierte la entrega a un mapa para serialización
  Map<String, dynamic> toMap() {
    return {
      'idEntrega': idEntrega,
      'idReserva': idReserva,
      'idVehiculo': idVehiculo,
      'fechaEntrega': fechaEntrega.millisecondsSinceEpoch,
      'observaciones': observaciones,
      'kilometrajeFinal': kilometrajeFinal,
      'estado': estado,
    };
  }

  /// Crea una entrega desde un mapa (deserialización)
  factory Entrega.fromMap(Map<String, dynamic> map) {
    return Entrega(
      idEntrega: map['idEntrega'],
      idReserva: map['idReserva'],
      idVehiculo: map['idVehiculo'],
      fechaEntrega: DateTime.fromMillisecondsSinceEpoch(map['fechaEntrega']),
      observaciones: map['observaciones'],
      kilometrajeFinal: map['kilometrajeFinal'],
      estado: map['estado'] ?? 'completada',
    );
  }
}
