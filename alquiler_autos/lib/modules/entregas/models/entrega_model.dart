/// Modelo de entrega para el sistema de alquiler
class Entrega {
  final int idEntrega;
  final int idReserva;
  DateTime fechaEntrega;
  String? observaciones;
  int? kilometrajeFinal;

  Entrega({
    required this.idEntrega,
    required this.idReserva,
    required this.fechaEntrega,
    this.observaciones,
    this.kilometrajeFinal,
  });

  /// Crea una copia de la entrega con valores actualizados
  Entrega copyWith({
    DateTime? fechaEntrega,
    String? observaciones,
    int? kilometrajeFinal,
  }) {
    return Entrega(
      idEntrega: idEntrega,
      idReserva: idReserva,
      fechaEntrega: fechaEntrega ?? this.fechaEntrega,
      observaciones: observaciones ?? this.observaciones,
      kilometrajeFinal: kilometrajeFinal ?? this.kilometrajeFinal,
    );
  }

  /// Convierte la entrega a un mapa para serialización
  Map<String, dynamic> toMap() {
    return {
      'idEntrega': idEntrega,
      'idReserva': idReserva,
      'fechaEntrega': fechaEntrega.millisecondsSinceEpoch,
      'observaciones': observaciones,
      'kilometrajeFinal': kilometrajeFinal,
    };
  }

  /// Crea una entrega desde un mapa (deserialización)
  factory Entrega.fromMap(Map<String, dynamic> map) {
    return Entrega(
      idEntrega: map['idEntrega'],
      idReserva: map['idReserva'],
      fechaEntrega: DateTime.fromMillisecondsSinceEpoch(map['fechaEntrega']),
      observaciones: map['observaciones'],
      kilometrajeFinal: map['kilometrajeFinal'],
    );
  }
}
