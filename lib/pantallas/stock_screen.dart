import 'package:flutter/material.dart';
import 'package:admin_kiosko/adaptadores/repositorio_de_productos_memoria.dart';
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

  @override
  void initState() {
    super.initState();
    productos = widget.productos;
  }

  // Actualiza la lista de productos consultando nuevamente al repositorio.
  Future<void> _actualizarProductos() async {
    final nuevosProductos =
        await RepositorioDeProductosMemoria().obtenerTodos();
    setState(() {
      productos = nuevosProductos;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPopNext() {
    // Cuando se regresa a esta pantalla, actualizar los productos.
    _actualizarProductos();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
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
                            trailing: Text("Stock: ${producto.stock}"),
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
              child: const Text("Cancelar"),
            ),
          ],
        ),
      ),
    );
  }
}
