import 'dart:async';
import 'package:admin_kiosko/dominio/cliente.dart';
import 'package:admin_kiosko/dominio/factura.dart';
import 'package:admin_kiosko/puertos/repositorio_de_clientes.dart';

class RepositorioDeClientesMemoria implements RepositorioDeClientes {
  final List<Cliente> _clientes = [];

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
