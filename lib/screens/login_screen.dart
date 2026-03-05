import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import 'products_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  Future<void> login() async {
    final user = UserModel(
      name: nameController.text,
      email: emailController.text,
    );

    await DatabaseService().insertUser(user);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ProductsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text("Ingresar")),
          ],
        ),
      ),
    );
  }
}

// DatabaseService is provided by lib/services/database_service.dart
