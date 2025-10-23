/// Modelo de cliente para el sistema de alquiler
class Cliente {
  final int idCliente;
  String nombre;
  String apellido;
  String numeroDocumento;

  Cliente({
    required this.idCliente,
    required this.nombre,
    required this.apellido,
    required this.numeroDocumento,
  });
  
  /// Crea una copia del cliente con valores actualizados
  Cliente copyWith({
    String? nombre,
    String? apellido,
    String? numeroDocumento,
  }) {
    return Cliente(
      idCliente: this.idCliente,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      numeroDocumento: numeroDocumento ?? this.numeroDocumento,
    );
  }
  
  /// Convierte el cliente a un mapa para serialización
  Map<String, dynamic> toMap() {
    return {
      'idCliente': idCliente,
      'nombre': nombre,
      'apellido': apellido,
      'numeroDocumento': numeroDocumento,
    };
  }
  
  /// Crea un cliente desde un mapa (deserialización)
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      idCliente: map['idCliente'],
      nombre: map['nombre'],
      apellido: map['apellido'],
      numeroDocumento: map['numeroDocumento'],
    );
  }
  
  @override
  String toString() {
    return '$nombre $apellido';
  }
}