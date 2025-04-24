import 'package:admin_kiosko/adaptadores/json/repositorio_de_producto_json.dart';
import 'package:flutter/material.dart';
import 'package:admin_kiosko/adaptadores/memoria/repositorio_de_productos_memoria.dart';
import 'package:admin_kiosko/dominio/mercaderia.dart';
import 'package:admin_kiosko/pantallas/menu_screen.dart';
import 'package:admin_kiosko/main.dart'; // Para acceder al routeObserver

class StockScreen extends StatefulWidget {
  final List<Mercaderia> productos;

  const StockScreen({super.key, required this.productos});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> with RouteAware {
  late List<Mercaderia> productos;
  late List<bool> enEdicion;
  late List<TextEditingController> controladores;

  @override
  void initState() {
    super.initState();
    productos = widget.productos;
    enEdicion = List<bool>.filled(productos.length, false);
    controladores =
        productos
            .map(
              (producto) =>
                  TextEditingController(text: producto.stock.toString()),
            )
            .toList();
  }

  Future<void> _actualizarProductos() async {
    final nuevosProductos =
        await RepositorioDeProductosMemoria().obtenerTodos();
    setState(() {
      productos = nuevosProductos;
      enEdicion = List<bool>.filled(productos.length, false);
      controladores =
          productos
              .map(
                (producto) =>
                    TextEditingController(text: producto.stock.toString()),
              )
              .toList();
    });
  }

  void _editarStock(int index) async {
    if (enEdicion[index]) {
      final nuevoStock = int.tryParse(controladores[index].text);
      if (nuevoStock != null) {
        final producto = productos[index];
        final actualizado = producto.copyWith(stock: nuevoStock);
        await RepositorioDeProductosMemoria().actualizarProducto(actualizado);

        setState(() {
          productos[index] = actualizado;
        });
      }
    }

    setState(() {
      enEdicion[index] = !enEdicion[index];
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPopNext() {
    _actualizarProductos();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    for (final controller in controladores) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stock de Productos")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child:
                  productos.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: productos.length,
                        itemBuilder: (context, index) {
                          final producto = productos[index];

                          return ListTile(
                            title: Text(producto.nombre),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 60,
                                  child:
                                      enEdicion[index]
                                          ? TextField(
                                            controller: controladores[index],
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              isDense: true,
                                              contentPadding: EdgeInsets.all(8),
                                            ),
                                          )
                                          : Text("Stock: ${producto.stock}"),
                                ),
                                IconButton(
                                  icon: Icon(
                                    enEdicion[index] ? Icons.check : Icons.edit,
                                    color:
                                        enEdicion[index] ? Colors.green : null,
                                  ),
                                  onPressed: () => _editarStock(index),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MenuScreen()),
                );
              },
              child: const Text("Menú"),
            ),
          ],
        ),
      ),
    );
  }
}
