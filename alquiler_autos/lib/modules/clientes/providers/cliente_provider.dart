import 'package:flutter/material.dart';
import '../models/cliente_model.dart';

/// Provider que gestiona la lista de clientes
class ClienteProvider extends ChangeNotifier {
  final List<Cliente> _clientes = [];
  int _nextId = 1;

  ClienteProvider() {
    _sembrarDatos();
  }

  List<Cliente> get clientes => List.unmodifiable(_clientes);

  /// Genera un nuevo identificador incremental
  int generarId() => _nextId++;

  /// Retorna los clientes ordenados por apellido y nombre
  List<Cliente> obtenerOrdenados() {
    final copia = List<Cliente>.from(_clientes);
    copia.sort(
      (a, b) => '${a.apellido} ${a.nombre}'.compareTo('${b.apellido} ${b.nombre}'),
    );
    return copia;
  }

  /// Agrega un nuevo cliente
  void agregar(Cliente cliente) {
    _clientes.add(cliente);
    notifyListeners();
  }

  /// Actualiza un cliente existente
  void actualizar(Cliente cliente) {
    final index = _clientes.indexWhere((c) => c.idCliente == cliente.idCliente);
    if (index != -1) {
      _clientes[index] = cliente;
      notifyListeners();
    }
  }

  /// Elimina un cliente por su identificador
  void eliminar(int id) {
    _clientes.removeWhere((c) => c.idCliente == id);
    notifyListeners();
  }

  /// Obtiene un cliente por su identificador
  Cliente? obtenerPorId(int id) {
    try {
      return _clientes.firstWhere((c) => c.idCliente == id);
    } catch (e) {
      return null;
    }
  }

  /// Verifica si un documento ya existe dentro de la lista
  bool documentoExiste(String documento, {int? excluirId}) {
    return _clientes.any(
      (c) => c.numeroDocumento == documento && (excluirId == null || c.idCliente != excluirId),
    );
  }

  /// Retorna una lista filtrada por nombre y/o documento
  List<Cliente> filtrar({String nombre = '', String documento = ''}) {
    final queryNombre = nombre.trim().toLowerCase();
    final queryDocumento = documento.trim();

    return _clientes.where((cliente) {
      final coincideNombre = queryNombre.isEmpty
          ? true
          : '${cliente.nombre} ${cliente.apellido}'.toLowerCase().contains(queryNombre);
      final coincideDocumento = queryDocumento.isEmpty
          ? true
          : cliente.numeroDocumento.contains(queryDocumento);
      return coincideNombre && coincideDocumento;
    }).toList();
  }

  void _sembrarDatos() {
    final iniciales = [
      Cliente(
        idCliente: generarId(),
        nombre: 'Juan',
        apellido: 'Pérez',
        numeroDocumento: '12345678',
      ),
      Cliente(
        idCliente: generarId(),
        nombre: 'María',
        apellido: 'González',
        numeroDocumento: '87654321',
      ),
      Cliente(
        idCliente: generarId(),
        nombre: 'Carlos',
        apellido: 'Rodríguez',
        numeroDocumento: '45678912',
      ),
    ];

    _clientes.addAll(iniciales);
  }
}