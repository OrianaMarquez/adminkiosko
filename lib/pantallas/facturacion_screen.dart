import 'package:flutter/material.dart';
import 'package:admin_kiosko/dominio/factura.dart';
import 'package:admin_kiosko/dominio/mercaderia.dart';
import 'package:admin_kiosko/dominio/cliente.dart';
import 'package:admin_kiosko/adaptadores/repositorio_de_productos_memoria.dart';
import 'package:admin_kiosko/adaptadores/repositorio_de_clientes_memoria.dart';
import 'package:admin_kiosko/casos_de_uso/facturacion.dart';

class FacturacionScreen extends StatefulWidget {
  final Factura factura;

  const FacturacionScreen({Key? key, required this.factura}) : super(key: key);

  @override
  State<FacturacionScreen> createState() => _FacturacionScreenState();
}

class _FacturacionScreenState extends State<FacturacionScreen> {
  late bool pagada;
  late DateTime fechaSeleccionada;

  List<Cliente> clientesDisponibles = [];
  String? selectedClienteId;

  @override
  void initState() {
    pagada = widget.factura.pagada;
    fechaSeleccionada = widget.factura.fecha;
    _cargarClientes();
    super.initState();
  }

  Future<void> _cargarClientes() async {
    // Se obtiene el listado de clientes desde el repositorio.
    final repoClientes = RepositorioDeClientesMemoria();
    final clientes = await repoClientes.obtenerTodos();
    setState(() {
      clientesDisponibles = clientes;
      // Por defecto se selecciona el primer cliente si existe.
      if (clientesDisponibles.isNotEmpty) {
        selectedClienteId = clientesDisponibles.first.id;
      }
    });
  }

  double calcularTotal() {
    double total = 0;
    for (final item in widget.factura.items) {
      total += item.cantidad * item.mercaderia.precio;
    }
    return total;
  }

  Future<void> _seleccionarFecha() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaSeleccionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != fechaSeleccionada) {
      setState(() {
        fechaSeleccionada = picked;
      });
    }
  }

  Future<void> _mostrarDialogoAgregarItem() async {
    final TextEditingController cantidadController = TextEditingController();
    // Se obtiene la lista de productos desde el repositorio.
    final repo = RepositorioDeProductosMemoria();
    final List<Mercaderia> productosDisponibles = await repo.obtenerTodos();
    String? selectedProductId;

    await showDialog(
      context: context,
      builder: (context) {
        // Usamos StatefulBuilder para poder actualizar el valor seleccionado.
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Agregar Item"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Selecciona la mercadería",
                    ),
                    value: selectedProductId,
                    items:
                        productosDisponibles.map((producto) {
                          return DropdownMenuItem<String>(
                            value: producto.id,
                            child: Text(producto.nombre),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setStateDialog(() {
                        selectedProductId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: cantidadController,
                    decoration: const InputDecoration(labelText: "Cantidad"),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final cantidad = int.tryParse(cantidadController.text) ?? 0;
                    if (selectedProductId != null && cantidad > 0) {
                      final productoSeleccionado = productosDisponibles
                          .firstWhere(
                            (producto) => producto.id == selectedProductId,
                          );
                      final nuevoItem = FacturaItem(
                        cantidad: cantidad,
                        mercaderia: productoSeleccionado,
                      );
                      setState(() {
                        widget.factura.items.add(nuevoItem);
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Agregar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmarVenta() {
    // Se crea una instancia de Facturacion y se invoca el método facturar.
    final facturacion = Facturacion(
      repositorioDeClientes: RepositorioDeClientesMemoria(),
      repositorioDeProductos: RepositorioDeProductosMemoria(),
    );
    facturacion.facturar(widget.factura).then((_) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("Venta Confirmada"),
              content: const Text("La venta se ha confirmado exitosamente."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = calcularTotal();
    return Scaffold(
      appBar: AppBar(title: const Text('Facturación')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Selector de fecha.
            Row(
              children: [
                const Text(
                  'Fecha: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _seleccionarFecha,
                  child: Text(
                    '${fechaSeleccionada.toLocal()}'.split(' ')[0],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Selector de cliente.
            Row(
              children: [
                const Text(
                  'Cliente: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child:
                      clientesDisponibles.isEmpty
                          ? const Text("Cargando clientes...")
                          : DropdownButton<String>(
                            isExpanded: true,
                            value: selectedClienteId,
                            items:
                                clientesDisponibles.map((cliente) {
                                  return DropdownMenuItem<String>(
                                    value: cliente.id,
                                    child: Text(cliente.nombre),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedClienteId = value;
                              });
                            },
                          ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Listado de items.
            const Text(
              'Items:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.factura.items.length,
                itemBuilder: (context, index) {
                  final item = widget.factura.items[index];
                  return ListTile(
                    title: Text(item.mercaderia.nombre),
                    subtitle: Text(
                      'Cantidad: ${item.cantidad} - Precio unitario: \$${item.mercaderia.precio.toStringAsFixed(2)}',
                    ),
                    trailing: Text(
                      '\$${(item.cantidad * item.mercaderia.precio).toStringAsFixed(2)}',
                    ),
                  );
                },
              ),
            ),
            // Total.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Casilla de verificación de factura pagada.
            Row(
              children: [
                const Text('Pagada:'),
                Checkbox(
                  value: pagada,
                  onChanged: (value) {
                    setState(() {
                      pagada = value ?? false;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Botón para confirmar la venta.
            ElevatedButton.icon(
              onPressed: _confirmarVenta,
              icon: const Icon(Icons.check),
              label: const Text("Confirmar Venta"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoAgregarItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
