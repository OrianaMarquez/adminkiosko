import 'package:admin_kiosko/dominio/factura.dart';
import 'package:hive/hive.dart';

part 'cliente.g.dart';

@HiveType(typeId: 0)
class Cliente extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String nombre;

  @HiveField(2)
  String correo;

  @HiveField(3)
  String telefono;

  @HiveField(4)
  DateTime fechaNacimiento;

  @HiveField(5)
  List<Factura> facturas;

  Cliente({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.fechaNacimiento,
    this.facturas = const [],
  });

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
