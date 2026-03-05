import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Product> cartItems;

  const CheckoutScreen({super.key, required this.cartItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  double getTotal() {
    double total = 0;
    for (var item in widget.cartItems) {
      total += item.price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D0C57),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D0C57),
        title: const Text("Carrito"),
      ),
      body: widget.cartItems.isEmpty
          ? const Center(
              child: Text(
                "Tu carrito está vacío",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : Column(
              children: [
                /// LISTA DE PRODUCTOS
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final product = widget.cartItems[index];

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.asset(product.image, width: 50),
                          title: Text(product.name),
                          subtitle: Text(
                            "\$${product.price.toStringAsFixed(2)}",
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// TOTAL + BOTÓN PAGAR
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Total: \$${getTotal().toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6F00),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PaymentScreen(
                                  cartItems: widget.cartItems,
                                  total: getTotal(),
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Pagar",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
