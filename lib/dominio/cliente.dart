import 'package:admin_kiosko/dominio/factura.dart';

class Cliente {
  final String id;
  final String nombre;
  final String correo;
  final String telefono;
  final DateTime fechaNacimiento;
  final List<Factura> facturas;

  Cliente({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.fechaNacimiento,
    List<Factura>? facturas,
  }) : facturas = facturas ?? [];

  int get edad {
    final today = DateTime.now();
    int age = today.year - fechaNacimiento.year;
    if (today.month < fechaNacimiento.month ||
        (today.month == fechaNacimiento.month &&
            today.day < fechaNacimiento.day)) {
      age--;
    }
    return age;
  }
}
