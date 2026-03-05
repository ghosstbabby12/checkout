class Product {
  final int id;
  final String name;
  final double price;
  final String? image;
  Product({required this.id, required this.name, required this.price, this.image});

  factory Product.fromMap(Map<String, Object?> m) => Product(
        id: m['id'] as int,
        name: m['name'] as String,
        price: (m['price'] as num).toDouble(),
        image: m['image'] as String?,
      );
}

class CartItem {
  final int cartId;
  final int productId;
  final String name;
  final double price;
  final String? image;
  final int qty;
  CartItem({
    required this.cartId,
    required this.productId,
    required this.name,
    required this.price,
    required this.qty,
    this.image,
  });

  double get subtotal => price * qty;

  factory CartItem.fromMap(Map<String, Object?> m) => CartItem(
        cartId: m['cartId'] as int,
        productId: m['productId'] as int,
        name: m['name'] as String,
        price: (m['price'] as num).toDouble(),
        qty: (m['qty'] as num).toInt(),
        image: m['image'] as String?,
      );
}

class UserModel {
  final int id;
  final String email;
  final String name;
  final String region;
  UserModel({required this.id, required this.email, required this.name, required this.region});
}
