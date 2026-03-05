import 'product_model.dart';

class CartItem {
  final int? id;
  final Product product;
  int quantity;

  CartItem({this.id, required this.product, this.quantity = 1});

  double get subtotal => product.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': product.id,
      'name': product.name,
      'price': product.price,
      'image': product.image,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      product: Product(
        id: map['productId'],
        name: map['name'],
        price: map['price'],
        image: map['image'],
      ),
      quantity: map['quantity'],
    );
  }
}
