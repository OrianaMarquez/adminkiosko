import 'dart:async';
import 'package:admin_kiosko/dominio/cliente.dart';
import 'package:admin_kiosko/dominio/factura.dart';
import 'package:admin_kiosko/puertos/repositorio_de_clientes.dart';

class RepositorioDeClientesMemoria implements RepositorioDeClientes {
  final List<Cliente> _clientes = [
    Cliente(
      id: '1',
      nombre: 'Juan Pérez',
      correo: 'juan.perez@example.com',
      telefono: '1234567890',
      fechaNacimiento: DateTime(1980, 7, 14),
    ),
    Cliente(
      id: '2',
      nombre: 'María López',
      correo: 'maria.lopez@example.com',
      telefono: '1122334455',
      fechaNacimiento: DateTime(1985, 5, 10),
    ),
    Cliente(
      id: '3',
      nombre: 'Carlos García',
      correo: 'carlos.garcia@example.com',
      telefono: '5566778899',
      fechaNacimiento: DateTime(1992, 1, 5),
    ),
    Cliente(
      id: '4',
      nombre: 'Ana Rodríguez',
      correo: 'ana.rodriguez@example.com',
      telefono: '9988776655',
      fechaNacimiento: DateTime(1990, 12, 21),
    ),
    Cliente(
      id: '5',
      nombre: 'Luis Martínez',
      correo: 'luis.martinez@example.com',
      telefono: '6677889900',
      fechaNacimiento: DateTime(1988, 3, 30),
    ),
    Cliente(
      id: '6',
      nombre: 'Sofía González',
      correo: 'sofia.gonzalez@example.com',
      telefono: '4433221100',
      fechaNacimiento: DateTime(1995, 9, 15),
    ),
  ];

  @override
  Future<List<Cliente>> obtenerTodos() async {
    return List<Cliente>.from(_clientes);
  }

  @override
  Future<Cliente?> obtenerPorId(String id) async {
    try {
      return _clientes.firstWhere((cliente) => cliente.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> crearCliente(Cliente cliente) async {
    _clientes.add(cliente);
  }

  @override
  Future<void> actualizarCliente(Cliente cliente) async {
    final index = _clientes.indexWhere((c) => c.id == cliente.id);
    if (index != -1) {
      _clientes[index] = cliente;
    }
  }

  @override
  Future<void> eliminarCliente(String id) async {
    _clientes.removeWhere((cliente) => cliente.id == id);
  }

  @override
  Future<void> agregarFactura(String clienteId, Factura factura) async {
    final cliente = await obtenerPorId(clienteId);
    if (cliente != null) {
      cliente.facturas.add(factura);
    }
  }
}
