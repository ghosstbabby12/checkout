import '../models/product_model.dart';
import '../services/database_service.dart';

class ProductService {
  Future<void> addSampleProducts() async {
    // Delegate to DatabaseService which already seeds example products with images
    await DatabaseService().seedProducts();
  }

  Future<List<Product>> fetchProducts() async {
    return await DatabaseService().getProducts();
  }
}
