import 'package:flutter/material.dart';
import '../services/database_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final items = await DatabaseService().getCart();
    setState(() => _items = items);
  }

  Future<void> _clearCart() async {
    await DatabaseService().clearCart();
    await _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrito')),
      body: _items.isEmpty
          ? const Center(child: Text('Tu carrito está vacío'))
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final it = _items[index];
                return ListTile(
                  leading: it['image'] != null && it['image'].toString().isNotEmpty
                      ? Image.network(
                          it['image'],
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
                        )
                      : const Icon(Icons.image_not_supported_outlined),
                  title: Text(it['name'] ?? ''),
                  subtitle: Text('\$${(it['price'] ?? 0).toString()} x ${it['quantity']}'),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _clearCart,
                child: const Text('Vaciar carrito'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
