import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDB {
  static final AppDB instance = AppDB._();
  AppDB._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'checkout_app.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT NOT NULL,
            name TEXT NOT NULL,
            region TEXT NOT NULL,
            createdAt INTEGER NOT NULL
          );
        ''');
        await db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            price REAL NOT NULL,
            image TEXT
          );
        ''');
        await db.execute('''
          CREATE TABLE cart (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER NOT NULL,
            productId INTEGER NOT NULL,
            qty INTEGER NOT NULL,
            UNIQUE(userId, productId)
          );
        ''');

        // Seed sample products
        final products = [
          ['Nike Air Zoom', 129.99, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800'],
          ['Apple AirPods Pro', 199.00, 'https://images.unsplash.com/photo-1588422333073-3b3b4a5b2f89?w=800'],
          ['Canon EOS M50', 589.00, 'https://images.unsplash.com/photo-1519183071298-a2962be96f83?w=800'],
          ['Xbox Controller', 59.90, 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=800'],
        ];
        for (final p in products) {
          await db.insert('products', {
            'name': p[0],
            'price': p[1],
            'image': p[2],
          });
        }
      },
    );
  }

  // USER
  Future<int> upsertUser(String email, String name, String region) async {
    final db = await database;
    final existing = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (existing.isNotEmpty) {
      final id = existing.first['id'] as int;
      await db.update('users', {'name': name, 'region': region}, where: 'id = ?', whereArgs: [id]);
      return id;
    }
    return db.insert('users', {
      'email': email,
      'name': name,
      'region': region,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<Map<String, Object?>?> getUserById(int id) async {
    final db = await database;
    final res = await db.query('users', where: 'id = ?', whereArgs: [id], limit: 1);
    return res.isNotEmpty ? res.first : null;
  }

  // PRODUCTS
  Future<List<Map<String, Object?>>> fetchProducts() async {
    final db = await database;
    return db.query('products');
  }

  // CART
  Future<void> addToCart(int userId, int productId, {int qty = 1}) async {
    final db = await database;
    final existing = await db.query('cart', where: 'userId = ? AND productId = ?', whereArgs: [userId, productId]);
    if (existing.isNotEmpty) {
      final row = existing.first;
      final id = row['id'] as int;
      final newQty = (row['qty'] as int) + qty;
      await db.update('cart', {'qty': newQty}, where: 'id = ?', whereArgs: [id]);
    } else {
      await db.insert('cart', {'userId': userId, 'productId': productId, 'qty': qty});
    }
  }

  Future<List<Map<String, Object?>>> fetchCart(int userId) async {
    final db = await database;
    return db.rawQuery('''
      SELECT c.id as cartId, c.qty, p.id as productId, p.name, p.price, p.image
      FROM cart c
      JOIN products p ON p.id = c.productId
      WHERE c.userId = ?
    ''', [userId]);
  }

  Future<void> clearCart(int userId) async {
    final db = await database;
    await db.delete('cart', where: 'userId = ?', whereArgs: [userId]);
  }
}
