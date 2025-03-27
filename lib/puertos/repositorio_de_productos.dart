import 'package:admin_kiosko/dominio/mercaderia.dart';
import 'package:admin_kiosko/dominio/factura.dart';

abstract class RepositorioDeProductos {
  /// Retorna todos los productos.
  Future<List<Mercaderia>> obtenerTodos();

  /// Retorna un producto por su id.
  Future<Mercaderia?> obtenerPorId(String id);

  /// Crea un nuevo producto.
  Future<void> crearProducto(Mercaderia producto);

  /// Actualiza un producto existente.
  Future<void> actualizarProducto(Mercaderia producto);

  /// Elimina un producto por su id.
  Future<void> eliminarProducto(String id);

  /// Aplica una factura y descuenta del stock de cada producto lo vendido.
  Future<void> aplicarFactura(Factura factura);
}
