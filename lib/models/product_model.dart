class Product {
  final int? id;
  final String name;
  final double price;
  final String image;

  Product({
    this.id,
    required this.name,
    required this.price,
    this.image = '',
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'price': price, 'image': image};
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    // Robust parsing with defaults and type conversions to avoid runtime errors
    final dynamic rawId = map['id'];
    final dynamic rawName = map['name'];
    final dynamic rawPrice = map['price'];
    final dynamic rawImage = map['image'];

    final int? id = rawId is int ? rawId : (rawId is String ? int.tryParse(rawId) : null);
    final String name = rawName?.toString() ?? '';
    double price;
    if (rawPrice is int) {
      price = rawPrice.toDouble();
    } else if (rawPrice is double) {
      price = rawPrice;
    } else if (rawPrice is String) {
      price = double.tryParse(rawPrice) ?? 0.0;
    } else {
      price = 0.0;
    }

    final String image = rawImage?.toString() ?? '';

    return Product(
      id: id,
      name: name,
      price: price,
      image: image,
    );
  }
}
