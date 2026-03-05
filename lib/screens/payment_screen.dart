import 'package:flutter/material.dart';
import '../models/product_model.dart';

class PaymentScreen extends StatelessWidget {
  final List<Product> cartItems;
  final double total;

  const PaymentScreen({
    super.key,
    required this.cartItems,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pago")),
      body: Center(
        child: Text(
          "Total a pagar: \$${total.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
