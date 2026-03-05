import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/database_service.dart';
import 'utils/logger.dart';
import 'screens/products_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize structured logging for development/devtools.
  initLogging();

  final db = DatabaseService();
  await db.seedProducts();

  // If a user already exists in the database, skip the login screen so
  // developers can get straight to the products list during testing.
  final users = await db.getUsers();
  final startAtProducts = users.isNotEmpty;

  runApp(MyApp(startAtProducts: startAtProducts));
}

class MyApp extends StatelessWidget {
  final bool startAtProducts;
  const MyApp({super.key, this.startAtProducts = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: startAtProducts ? const ProductsScreen() : const LoginScreen(),
    );
  }
}
