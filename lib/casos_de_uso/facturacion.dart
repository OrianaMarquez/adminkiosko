import 'package:admin_kiosko/dominio/factura.dart';
import 'package:admin_kiosko/puertos/repositorio_de_clientes.dart';
import 'package:admin_kiosko/puertos/repositorio_de_productos.dart';

class Facturacion {
  final RepositorioDeClientes repositorioDeClientes;
  final RepositorioDeProductos repositorioDeProductos;

  Facturacion({
    required this.repositorioDeClientes,
    required this.repositorioDeProductos,
  });

  Future<void> facturar(Factura factura) async {
    // Agrega la factura al cliente.
    await repositorioDeClientes.agregarFactura(factura.cliente.id, factura);

    // Decrementa el stock de los productos de la factura.
    await repositorioDeProductos.aplicarFactura(factura);

    // Mostrar listado de productos con su respectivo stock.
    final productos = await repositorioDeProductos.obtenerTodos();
    print("Listado de productos y su stock:");
    for (final producto in productos) {
      print("${producto.nombre}: ${producto.stock}");
    }
  }
}
