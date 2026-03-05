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

  // ==============================
  // INIT DATABASE
  // ==============================

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'checkout.db');

    return await openDatabase(
      path,
      version: 2, // 🔥 IMPORTANTE subir versión
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS users');
        await db.execute('DROP TABLE IF EXISTS products');
        await db.execute('DROP TABLE IF EXISTS cart');
        await _onCreate(db, newVersion);
      },
    );
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

  // ==============================
  // USERS
  // ==============================

  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<List<UserModel>> getUsers() async {
    final db = await database;
    final maps = await db.query('users');
    return maps.map((e) => UserModel.fromMap(e)).toList();
  }

  // ==============================
  // PRODUCTS
  // ==============================

  Future<void> seedProducts() async {
    final db = await database;

    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM products'),
    );

    if (count == 0) {
      await db.insert('products', {
        'name': 'Nike Air Max',
        'price': 120.0,
        'image': 'https://static.nike.com/a/images/t_default/8e6d1a6f-1.jpg',
      });

      await db.insert('products', {
        'name': 'Adidas Ultraboost',
        'price': 150.0,
        'image':
            'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/ultraboost.jpg',
      });

      await db.insert('products', {
        'name': 'Puma Runner',
        'price': 95.0,
        'image':
            'https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa/global/runner.jpg',
      });
    }
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final maps = await db.query('products');
    return maps.map((e) => Product.fromMap(e)).toList();
  }

  // ==============================
  // CART
  // ==============================

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
}
