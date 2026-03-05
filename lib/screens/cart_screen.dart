import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../db/app_db.dart';
import '../models/models.dart';
import '../utils/currency.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late int userId;
  String region = 'US';
  List<CartItem> items = [];
  double total = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, Object?>?;
    userId = (args?['userId'] as int?) ?? 1;
    _loadAll();
  }

  Future<void> _loadAll() async {
    final u = await AppDB.instance.getUserById(userId);
    region = (u?['region'] as String?) ?? 'US';
    final rows = await AppDB.instance.fetchCart(userId);
    items = rows.map((m) => CartItem.fromMap(m)).toList();
    total = items.fold(0.0, (sum, i) => sum + i.subtotal);
    setState(() {});
  }

  void _goToPay() {
    Navigator.pushNamed(context, '/payment', arguments: total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your cart')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final it = items[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: it.image ?? '',
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorWidget: (c, _, __) => const Icon(Icons.image_not_supported_outlined),
                    ),
                  ),
                  title: Text(it.name),
                  subtitle: Text('${CurrencyHelper.format(it.price, region)}  x${it.qty}'),
                  trailing: Text(CurrencyHelper.format(it.subtotal, region), style: const TextStyle(fontWeight: FontWeight.w700)),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))]),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total', style: TextStyle(color: Colors.grey)),
                      Text(CurrencyHelper.format(total, region), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: items.isEmpty ? null : _goToPay,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                  child: const Text('Pagar'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
