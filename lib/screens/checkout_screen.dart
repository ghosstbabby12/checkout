import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'payment_screen.dart';

class CheckoutScreen extends StatelessWidget {
  final Product product;

  const CheckoutScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(product.name, style: const TextStyle(fontSize: 22)),
            Text("\$${product.price}", style: const TextStyle(fontSize: 20)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentScreen(product: product),
                  ),
                );
              },
              child: const Text("Realizar Pago"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar Pago"),
            ),
          ],
        ),
      ),
    );
  }
}
