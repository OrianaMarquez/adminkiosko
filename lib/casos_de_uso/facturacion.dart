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

    print('Factura procesada para: ${factura.cliente.nombre}');
  }
}
