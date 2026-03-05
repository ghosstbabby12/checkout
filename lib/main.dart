import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = DatabaseService();
  await db.seedProducts();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
