import 'package:flutter/material.dart';
import 'package:admin_kiosko/dominio/cliente.dart';
import 'package:admin_kiosko/dominio/factura.dart';
import 'package:admin_kiosko/pantallas/facturacion_screen.dart';
import 'package:admin_kiosko/pantallas/stock_screen.dart';
import 'package:admin_kiosko/adaptadores/repositorio_de_productos_memoria.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  Factura createDummyFactura() {
    final dummyCliente = Cliente(
      id: '1',
      nombre: 'Juan Pérez',
      correo: 'juan.perez@example.com',
      telefono: '1234567890',
      fechaNacimiento: DateTime(1990, 1, 1),
    );
    return Factura(
      cliente: dummyCliente,
      fecha: DateTime.now(),
      items: [],
      pagada: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menú")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                final factura = createDummyFactura();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FacturacionScreen(factura: factura),
                  ),
                );
              },
              child: const Text("Facturar"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final productos =
                    await RepositorioDeProductosMemoria().obtenerTodos();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StockScreen(productos: productos),
                  ),
                );
              },
              child: const Text("Cargar stock"),
            ),
          ],
        ),
      ),
    );
  }
}
