import 'package:admin_kiosko/dominio/cliente.dart';
import 'package:admin_kiosko/dominio/mercaderia.dart';

class FacturaItem {
  final int cantidad;
  final Mercaderia mercaderia;

  FacturaItem({required this.cantidad, required this.mercaderia});
}

class Factura {
  final Cliente cliente;
  final DateTime fecha;
  final List<FacturaItem> items;
  final bool pagada;

  Factura({
    required this.cliente,
    required this.fecha,
    required this.items,
    this.pagada = false,
  });
}
