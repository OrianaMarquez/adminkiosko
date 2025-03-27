import 'dart:async';
import 'package:admin_kiosko/dominio/mercaderia.dart';
import 'package:admin_kiosko/dominio/factura.dart';
import 'package:admin_kiosko/puertos/repositorio_de_productos.dart';

class RepositorioDeProductosMemoria implements RepositorioDeProductos {
  final List<Mercaderia> _productos = [];

  @override
  Future<List<Mercaderia>> obtenerTodos() async {
    return List<Mercaderia>.from(_productos);
  }

  @override
  Future<Mercaderia?> obtenerPorId(String id) async {
    try {
      return _productos.firstWhere((producto) => producto.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> crearProducto(Mercaderia producto) async {
    _productos.add(producto);
  }

  @override
  Future<void> actualizarProducto(Mercaderia producto) async {
    final index = _productos.indexWhere((p) => p.id == producto.id);
    if (index != -1) {
      _productos[index] = producto;
    }
  }

  @override
  Future<void> eliminarProducto(String id) async {
    _productos.removeWhere((producto) => producto.id == id);
  }

  @override
  Future<void> aplicarFactura(Factura factura) async {
    for (final item in factura.items) {
      final index = _productos.indexWhere((p) => p.id == item.mercaderia.id);
      if (index != -1) {
        final producto = _productos[index];
        // Se descuenta la cantidad vendida del stock actual.
        final nuevoStock = producto.stock - item.cantidad;
        // Puedes implementar validaciones para que nuevoStock no sea negativo.
        _productos[index] = producto.copyWith(stock: nuevoStock);
      }
    }
  }
}
