import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';
import '../services/database_service.dart';
import 'checkout_screen.dart';
import 'cart_screen.dart';
import 'account_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> products = [];
  final service = ProductService();
  int _cartCount = 0;

  Future<void> _updateCartCount() async {
    final items = await DatabaseService().getCart();
    setState(() => _cartCount = items.length);
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    // Ensure products are seeded using the DatabaseService (robust seeding)
    await DatabaseService().seedProducts();
    products = await DatabaseService().getProducts();
    await _updateCartCount();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountScreen())),
            tooltip: 'Mi cuenta',
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                tooltip: 'Ver carrito',
              ),
              if (_cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text('$_cartCount', style: const TextStyle(color: Colors.white, fontSize: 10), textAlign: TextAlign.center),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: products.isEmpty
          ? const Center(child: Text('No products yet', style: TextStyle(color: Colors.black54)))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final p = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: SizedBox(
                      width: 56,
                      height: 56,
                      child: p.image.isNotEmpty
                          ? Image.network(
                              p.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
                            )
                          : const Icon(Icons.image_not_supported_outlined),
                    ),
                    title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('\$${p.price.toStringAsFixed(2)}'),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        await DatabaseService().addToCart(p.id ?? 0, 1);
                        messenger.showSnackBar(const SnackBar(content: Text('Added to cart')));
                        await _updateCartCount();
                      },
                      child: const Text('Add'),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutScreen(product: p)));
                    },
                  ),
                );
              },
            ),
    );
  }
}
