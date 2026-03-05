import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user_model.dart';
import '../models/product_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'checkout.db');

    // bump DB version to 2 and provide onUpgrade to add missing columns
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // If upgrading from version 1 -> 2, add the `image` column to products table if missing.
    if (oldVersion < 2) {
      try {
        await db.execute("ALTER TABLE products ADD COLUMN image TEXT DEFAULT ''");
      } catch (e) {
        // ignore if column already exists or other issue; safe to continue
      }
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        image TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE cart(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER NOT NULL,
        quantity INTEGER NOT NULL
      )
    ''');
  }

  // =========================
  // USERS
  // =========================

  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<List<UserModel>> getUsers() async {
    final db = await database;
    final maps = await db.query('users');

    return maps.map((e) => UserModel.fromMap(e)).toList();
  }

  // =========================
  // PRODUCTS
  // =========================

  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final maps = await db.query('products');

    // Debug logging to help diagnose empty results
    try {
      print('DatabaseService.getProducts: fetched ${maps.length} rows from products');
    } catch (_) {}

    return maps.map((e) => Product.fromMap(e)).toList();
  }

  Future<Product?> getProductById(int id) async {
    final db = await database;
    final maps = await db.query('products', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }

    return null; // 🔥 ahora sí retorna algo siempre
  }

  // Seed products if table is empty
  Future<void> seedProducts() async {
    final db = await database;

    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM products'),
    );

    try {
      print('DatabaseService.seedProducts: products count = $count');
    } catch (_) {}

    if (count == 0) {
      await db.insert('products', {
        'name': 'Nike Air Max',
        'price': 120.0,
        'image': 'https://static.nike.com/a/images/t_default/air-max.jpg'
      });

      await db.insert('products', {
        'name': 'Adidas Ultraboost',
        'price': 150.0,
        'image': 'https://assets.adidas.com/images/ultraboost.jpg'
      });

      await db.insert('products', {
        'name': 'Puma Runner',
        'price': 95.0,
        'image': 'https://images.puma.com/runner.jpg'
      });
      try {
        print('DatabaseService.seedProducts: inserted sample products');
      } catch (_) {}
    }
  }

  // =========================
  // CART
  // =========================

  Future<int> addToCart(int productId, int quantity) async {
    final db = await database;

    return await db.insert('cart', {
      'productId': productId,
      'quantity': quantity,
    });
  }

  Future<List<Map<String, dynamic>>> getCart() async {
    final db = await database;

    return await db.rawQuery('''
      SELECT cart.id, products.name, products.price, products.image, cart.quantity
      FROM cart
      INNER JOIN products ON products.id = cart.productId
    ''');
  }

  Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
