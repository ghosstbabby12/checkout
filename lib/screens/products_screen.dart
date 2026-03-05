import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../db/app_db.dart';
import '../models/models.dart';
import '../utils/currency.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late int userId;
  String region = 'US';
  List<Product> products = [];
  int cartCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, Object?>?;
    userId = (args?['userId'] as int?) ?? 1;
    _loadUser();
    _loadProducts();
    _loadCartCount();
  }

  Future<void> _loadUser() async {
    final u = await AppDB.instance.getUserById(userId);
    if (u != null) setState(() => region = (u['region'] as String?) ?? 'US');
  }

  Future<void> _loadProducts() async {
    final rows = await AppDB.instance.fetchProducts();
    setState(() => products = rows.map((m) => Product.fromMap(m)).toList());
  }

  Future<void> _loadCartCount() async {
    final rows = await AppDB.instance.fetchCart(userId);
    int count = 0;
    for (final r in rows) {
      count += (r['qty'] as int);
    }
    setState(() => cartCount = count);
  }

  Future<void> _addToCart(Product p) async {
    await AppDB.instance.addToCart(userId, p.id, qty: 1);
    await _loadCartCount();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${p.name} added to cart')), 
    );
  }

  void _openCart() async {
    await Navigator.pushNamed(context, '/cart', arguments: {'userId': userId});
    if (!mounted) return;
    _loadCartCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: _openCart,
              ),
              if (cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.red,
                    child: Text('$cartCount', style: const TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                )
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadProducts();
          await _loadCartCount();
        },
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final p = products[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: p.image ?? '',
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    placeholder: (c, _) => const SizedBox(width: 56, height: 56, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                    errorWidget: (c, _, __) => const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
                title: Text(p.name),
                subtitle: Text(CurrencyHelper.format(p.price, region)),
                trailing: ElevatedButton(
                  onPressed: () => _addToCart(p),
                  child: const Text('Add'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
