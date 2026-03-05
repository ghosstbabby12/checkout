import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const ProductCard({required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(product.image, height: 150, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$${product.price}",
                  style: const TextStyle(color: AppTheme.primary),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: onAdd,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: AppTheme.mainGradient,
                    ),
                    child: const Center(
                      child: Text(
                        "Add to Cart",
                        style: TextStyle(color: Colors.white),
                      ),
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
