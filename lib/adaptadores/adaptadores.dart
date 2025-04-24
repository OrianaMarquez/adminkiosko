import 'package:admin_kiosko/adaptadores/memoria/repositorio_de_clientes_memoria.dart';
import 'package:admin_kiosko/adaptadores/memoria/repositorio_de_productos_memoria.dart';
import 'package:admin_kiosko/puertos/repositorio_de_clientes.dart';
import 'package:admin_kiosko/puertos/repositorio_de_productos.dart';

class Adaptadores {
  late RepositorioDeClientes repoClientes;
  late RepositorioDeProductos repoProductos;

  Adaptadores._inicial() {
    repoClientes = RepositorioDeClientesMemoria();
    repoProductos = RepositorioDeProductosMemoria();
  }

  static final Adaptadores _singleton = Adaptadores._inicial();

  factory Adaptadores() {
    return _singleton;
  }
}
