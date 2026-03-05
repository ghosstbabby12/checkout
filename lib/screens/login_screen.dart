import 'package:flutter/material.dart';
import '../db/app_db.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController(text: 'camila@example.com');
  final _name = TextEditingController(text: 'Camila');
  String _region = 'US';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Email'),
            TextField(controller: _email),
            const SizedBox(height: 12),
            const Text('Name'),
            TextField(controller: _name),
            const SizedBox(height: 12),
            const Text('Region'),
            DropdownButton<String>(
              value: _region,
              items: const [
                DropdownMenuItem(value: 'US', child: Text('United States')),
                DropdownMenuItem(value: 'MX', child: Text('Mexico')),
                DropdownMenuItem(value: 'CO', child: Text('Colombia')),
                DropdownMenuItem(value: 'ES', child: Text('Spain')),
              ],
              onChanged: (v) => setState(() => _region = v ?? 'US'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final id = await AppDB.instance.upsertUser(_email.text.trim(), _name.text.trim(), _region);
                  if (!mounted) return;
                  Navigator.pushReplacementNamed(context, '/products', arguments: {'userId': id});
                },
                child: const Text('Continue'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
