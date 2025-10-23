class Entrega {
  final int idEntrega;
  final int idReserva;
  DateTime fechaEntregaReal;
  String? observaciones;
  int? kilometrajeFinal;

  Entrega({
    required this.idEntrega,
    required this.idReserva,
    required this.fechaEntregaReal,
    this.observaciones,
    this.kilometrajeFinal,
  });
}
