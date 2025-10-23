import 'package:flutter/material.dart';
import '../models/cliente_model.dart';

/// Provider que gestiona la lista de clientes
class ClienteProvider extends ChangeNotifier {
  // Lista interna de clientes
  final List<Cliente> _clientes = [];
  
  // ID autoincrementable para nuevos clientes
  int _nextId = 1;
  
  // Constructor
  ClienteProvider() {
    // Aquí se pueden agregar clientes de ejemplo
    _agregarClientesDePrueba();
  }
  
  // Getter para obtener una copia de la lista de clientes
  List<Cliente> get clientes => List.unmodifiable(_clientes);
  
  // Obtener el siguiente ID disponible
  int get nextId => _nextId++;
  
  /// Agregar un nuevo cliente a la lista
  void agregar(Cliente cliente) {
    _clientes.add(cliente);
    notifyListeners();
  }
  
  /// Actualizar un cliente existente
  void actualizar(Cliente cliente) {
    final index = _clientes.indexWhere((c) => c.idCliente == cliente.idCliente);
    
    if (index != -1) {
      _clientes[index] = cliente;
      notifyListeners();
    }
  }
  
  /// Eliminar un cliente por su ID
  void eliminar(int id) {
    _clientes.removeWhere((cliente) => cliente.idCliente == id);
    notifyListeners();
  }
  
  /// Obtener un cliente por su ID
  Cliente? obtenerPorId(int id) {
    try {
      return _clientes.firstWhere((c) => c.idCliente == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Filtrar clientes por nombre y apellido
  List<Cliente> filtrarPorNombreCompleto(String query) {
    if (query.isEmpty) return clientes;
    
    query = query.toLowerCase();
    return _clientes.where(
      (c) => '${c.nombre} ${c.apellido}'.toLowerCase().contains(query)
    ).toList();
  }
  
  /// Filtrar clientes por número de documento
  List<Cliente> filtrarPorDocumento(String documento) {
    if (documento.isEmpty) return clientes;
    
    return _clientes.where(
      (c) => c.numeroDocumento.contains(documento)
    ).toList();
  }
  
  /// Verificar si un número de documento ya existe
  bool documentoExiste(String documento, {int? excludeId}) {
    return _clientes.any((c) => 
      c.numeroDocumento == documento && (excludeId == null || c.idCliente != excludeId)
    );
  }
  
  /// Método privado para agregar clientes de ejemplo
  void _agregarClientesDePrueba() {
    agregar(Cliente(
      idCliente: nextId,
      nombre: 'Juan',
      apellido: 'Pérez',
      numeroDocumento: '12345678',
    ));
    
    agregar(Cliente(
      idCliente: nextId,
      nombre: 'María',
      apellido: 'González',
      numeroDocumento: '87654321',
    ));
    
    agregar(Cliente(
      idCliente: nextId,
      nombre: 'Carlos',
      apellido: 'Rodríguez',
      numeroDocumento: '45678912',
    ));
  }
}