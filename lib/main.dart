import 'package:flutter/material.dart';
import 'package:admin_kiosko/dominio/factura.dart';
import 'package:admin_kiosko/dominio/cliente.dart';
import 'package:admin_kiosko/pantallas/facturacion_screen.dart';

void main() {
  final dummyCliente = Cliente(
    id: '1',
    nombre: 'Juan Pérez',
    correo: 'juan.perez@example.com',
    telefono: '1234567890',
    fechaNacimiento: DateTime(1990, 1, 1),
  );

  final dummyFactura = Factura(
    cliente: dummyCliente,
    fecha: DateTime.now(),
    items: [], // Lista de items vacía para ir agregando.
    pagada: false,
  );

  runApp(MyApp(factura: dummyFactura));
}

class MyApp extends StatelessWidget {
  final Factura factura;

  const MyApp({super.key, required this.factura});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Facturación',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FacturacionScreen(factura: factura),
    );
  }
}
