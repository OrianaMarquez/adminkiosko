import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:admin_kiosko/dominio/mercaderia.dart';
import 'package:admin_kiosko/dominio/factura.dart';
import 'package:admin_kiosko/puertos/repositorio_de_productos.dart';
import 'package:path_provider/path_provider.dart';

class RepositorioDeProductosArchivo implements RepositorioDeProductos {
  late final File _archivo;

  RepositorioDeProductosArchivo() {
    _inicializarArchivo();
  }

  Future<void> _inicializarArchivo() async {
    final dir = await getApplicationDocumentsDirectory();
    _archivo = File('${dir.path}/productos.json');

    if (!await _archivo.exists()) {
      await _archivo.writeAsString(jsonEncode([]));
    }
  }

  Future<List<Mercaderia>> _leerProductos() async {
    await _inicializarArchivo(); // Asegura que el archivo esté listo
    final contenido = await _archivo.readAsString();
    final List<dynamic> jsonData = jsonDecode(contenido);
    return jsonData.map((item) => Mercaderia.fromJson(item)).toList();
  }

  Future<void> _guardarProductos(List<Mercaderia> productos) async {
    final json = productos.map((p) => p.toJson()).toList();
    await _archivo.writeAsString(jsonEncode(json), flush: true);
  }

  @override
  Future<List<Mercaderia>> obtenerTodos() async {
    return await _leerProductos();
  }

  @override
  Future<Mercaderia?> obtenerPorId(String id) async {
    final productos = await _leerProductos();
    try {
      return productos.firstWhere((producto) => producto.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> crearProducto(Mercaderia producto) async {
    final productos = await _leerProductos();
    productos.add(producto);
    await _guardarProductos(productos);
  }

  @override
  Future<void> actualizarProducto(Mercaderia producto) async {
    final productos = await _leerProductos();
    final index = productos.indexWhere((p) => p.id == producto.id);
    if (index != -1) {
      productos[index] = producto;
      await _guardarProductos(productos);
    }
  }

  @override
  Future<void> eliminarProducto(String id) async {
    final productos = await _leerProductos();
    productos.removeWhere((p) => p.id == id);
    await _guardarProductos(productos);
  }

  @override
  Future<void> aplicarFactura(Factura factura) async {
    final productos = await _leerProductos();
    for (final item in factura.items) {
      final index = productos.indexWhere((p) => p.id == item.mercaderia.id);
      if (index != -1) {
        final producto = productos[index];
        final nuevoStock = producto.stock - item.cantidad;
        productos[index] = producto.copyWith(stock: nuevoStock);
      }
    }
    await _guardarProductos(productos);
  }
}
