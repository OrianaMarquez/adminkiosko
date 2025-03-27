import 'dart:async';
import 'package:admin_kiosko/dominio/mercaderia.dart';
import 'package:admin_kiosko/dominio/factura.dart';
import 'package:admin_kiosko/puertos/repositorio_de_productos.dart';

class RepositorioDeProductosMemoria implements RepositorioDeProductos {
  final List<Mercaderia> _productos = [
    Mercaderia(
      id: '1',
      nombre: 'Chupetin',
      descripcion: 'Delicioso chupetín',
      precio: 1.0,
      stock: 20,
    ),
    Mercaderia(
      id: '2',
      nombre: 'Caramelo',
      descripcion: 'Dulce caramelo',
      precio: 0.5,
      stock: 20,
    ),
    Mercaderia(
      id: '3',
      nombre: 'Chicle',
      descripcion: 'Chicle para masticar',
      precio: 0.8,
      stock: 20,
    ),
    Mercaderia(
      id: '4',
      nombre: 'Jugo',
      descripcion: 'Jugo refrescante',
      precio: 2.0,
      stock: 20,
    ),
    Mercaderia(
      id: '5',
      nombre: 'Alfajor',
      descripcion: 'Alfajor tradicional',
      precio: 1.5,
      stock: 20,
    ),
  ];

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
        final nuevoStock = producto.stock - item.cantidad;
        _productos[index] = producto.copyWith(stock: nuevoStock);
      }
    }
  }
}
