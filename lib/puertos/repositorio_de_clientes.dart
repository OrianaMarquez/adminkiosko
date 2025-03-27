import 'package:admin_kiosko/dominio/cliente.dart';
import 'package:admin_kiosko/dominio/factura.dart';

abstract class RepositorioDeClientes {
  /// Retorna todos los clientes.
  Future<List<Cliente>> obtenerTodos();

  /// Retorna un cliente por su id.
  Future<Cliente?> obtenerPorId(String id);

  /// Crea un nuevo cliente.
  Future<void> crearCliente(Cliente cliente);

  /// Actualiza un cliente existente.
  Future<void> actualizarCliente(Cliente cliente);

  /// Elimina un cliente por su id.
  Future<void> eliminarCliente(String id);

  /// Agrega una factura a un cliente.
  Future<void> agregarFactura(String clienteId, Factura factura);
}
