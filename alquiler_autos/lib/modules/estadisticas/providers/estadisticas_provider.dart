import 'package:flutter/foundation.dart';
import '../../vehiculos/providers/vehiculo_provider.dart';
import '../../reservas/providers/reserva_provider.dart';
import '../../clientes/providers/cliente_provider.dart';

/// Provider que gestiona las estadísticas del sistema
class EstadisticasProvider with ChangeNotifier {
  final VehiculoProvider _vehiculoProvider;
  final ReservaProvider _reservaProvider;
  final ClienteProvider _clienteProvider;

  EstadisticasProvider({
    required VehiculoProvider vehiculoProvider,
    required ReservaProvider reservaProvider,
    required ClienteProvider clienteProvider,
  })  : _vehiculoProvider = vehiculoProvider,
        _reservaProvider = reservaProvider,
        _clienteProvider = clienteProvider {
    // Escuchar cambios en los providers
    _vehiculoProvider.addListener(_notifyChanges);
    _reservaProvider.addListener(_notifyChanges);
    _clienteProvider.addListener(_notifyChanges);
  }

  void _notifyChanges() {
    notifyListeners();
  }

  /// Obtiene el total de reservas activas (confirmadas o pendientes)
  int get totalReservasActivas {
    return _reservaProvider.reservas
        .where((r) => r.estado == 'confirmada' || r.estado == 'pendiente')
        .length;
  }

  /// Obtiene la cantidad de vehículos disponibles
  int get cantidadVehiculosDisponibles {
    return _vehiculoProvider.vehiculos.where((v) => v.disponible).length;
  }

  /// Obtiene el cliente con más reservas realizadas
  Map<String, dynamic>? get clienteConMasReservas {
    if (_clienteProvider.clientes.isEmpty || _reservaProvider.reservas.isEmpty) {
      return null;
    }

    // Contar reservas por cliente
    final Map<int, int> reservasPorCliente = {};

    for (var reserva in _reservaProvider.reservas) {
      reservasPorCliente[reserva.idCliente] =
          (reservasPorCliente[reserva.idCliente] ?? 0) + 1;
    }

    // Encontrar el cliente con más reservas
    int clienteId = 0;
    int maxReservas = 0;

    reservasPorCliente.forEach((id, cantidad) {
      if (cantidad > maxReservas) {
        maxReservas = cantidad;
        clienteId = id;
      }
    });

    if (maxReservas == 0) {
      return null;
    }

    // Obtener información del cliente
    final cliente = _clienteProvider.obtenerPorId(clienteId);
    
    if (cliente == null) {
      return null;
    }

    return {
      'nombre': '${cliente.nombre} ${cliente.apellido}',
      'cantidadReservas': maxReservas,
    };
  }

  /// Obtiene el total de vehículos en el sistema
  int get totalVehiculos => _vehiculoProvider.vehiculos.length;

  /// Obtiene el total de clientes en el sistema
  int get totalClientes => _clienteProvider.clientes.length;

  /// Obtiene el total de reservas en el sistema
  int get totalReservas => _reservaProvider.reservas.length;

  /// Obtiene las reservas confirmadas
  int get reservasConfirmadas {
    return _reservaProvider.reservas.where((r) => r.estado == 'confirmada').length;
  }

  /// Obtiene las reservas pendientes
  int get reservasPendientes {
    return _reservaProvider.reservas.where((r) => r.estado == 'pendiente').length;
  }

  /// Obtiene las reservas finalizadas
  int get reservasFinalizadas {
    return _reservaProvider.reservas.where((r) => r.estado == 'finalizada').length;
  }

  /// Obtiene las reservas canceladas
  int get reservasCanceladas {
    return _reservaProvider.reservas.where((r) => r.estado == 'cancelada').length;
  }

  @override
  void dispose() {
    _vehiculoProvider.removeListener(_notifyChanges);
    _reservaProvider.removeListener(_notifyChanges);
    _clienteProvider.removeListener(_notifyChanges);
    super.dispose();
  }
}
