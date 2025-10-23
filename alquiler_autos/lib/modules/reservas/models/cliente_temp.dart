/// Modelo temporal de cliente hasta que se implemente el módulo completo
class ClienteTemp {
  final int id;
  final String nombre;
  final String dni;
  final String telefono;

  ClienteTemp({
    required this.id,
    required this.nombre,
    required this.dni,
    required this.telefono,
  });

  @override
  String toString() => nombre;
}

/// Lista estática de clientes para usar mientras no existe el módulo
class ClientesData {
  static final List<ClienteTemp> clientes = [
    ClienteTemp(
      id: 1,
      nombre: 'Juan Pérez',
      dni: '12345678',
      telefono: '3511234567',
    ),
    ClienteTemp(
      id: 2,
      nombre: 'María González',
      dni: '23456789',
      telefono: '3512345678',
    ),
    ClienteTemp(
      id: 3,
      nombre: 'Carlos Rodríguez',
      dni: '34567890',
      telefono: '3513456789',
    ),
    ClienteTemp(
      id: 4,
      nombre: 'Ana Martínez',
      dni: '45678901',
      telefono: '3514567890',
    ),
    ClienteTemp(
      id: 5,
      nombre: 'Luis Fernández',
      dni: '56789012',
      telefono: '3515678901',
    ),
  ];

  static ClienteTemp? obtenerPorId(int id) {
    try {
      return clientes.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}