import 'package:hive/hive.dart';
import 'package:admin_kiosko/dominio/cliente.dart';
import 'package:admin_kiosko/dominio/factura.dart';
import 'package:admin_kiosko/puertos/repositorio_de_clientes.dart';

class RepositorioDeClientesHive implements RepositorioDeClientes {
  final Box<Cliente> _clientesBox = Hive.box<Cliente>('clientes');

  @override
  Future<List<Cliente>> obtenerTodos() async {
    return _clientesBox.values.toList();
  }

  @override
  Future<Cliente?> obtenerPorId(String id) async {
    try {
      return _clientesBox.values.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> crearCliente(Cliente cliente) async {
    await _clientesBox.put(cliente.id, cliente);
  }

  @override
  Future<void> actualizarCliente(Cliente cliente) async {
    await _clientesBox.put(cliente.id, cliente);
  }

  @override
  Future<void> eliminarCliente(String id) async {
    await _clientesBox.delete(id);
  }

  @override
  Future<void> agregarFactura(String clienteId, Factura factura) async {
    final cliente = await obtenerPorId(clienteId);
    if (cliente != null) {
      cliente.facturas.add(factura);
      await _clientesBox.put(clienteId, cliente);
    }
  }
}
