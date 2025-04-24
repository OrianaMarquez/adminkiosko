import 'package:admin_kiosko/dominio/cliente.dart';
import 'package:flutter/material.dart';
import 'package:admin_kiosko/pantallas/menu_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  Hive.registerAdapter(ClienteAdapter());
  // Hive.registerAdapter(FacturaAdapter()); // si usás Factura también

  await Hive.openBox<Cliente>('clientes');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Facturación',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MenuScreen(),
      navigatorObservers: [routeObserver],
    );
  }
}
