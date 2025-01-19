
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbModel {
  DbModel._privateConstructor();
  static final DbModel instance = DbModel._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'product.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE product (
        idInvoice INTEGER PRIMARY KEY AUTOINCREMENT,
        idproduct int
        datetime TEXT NOT NULL,
        status TEXT
      )
    ''');
  }

  Future<int> insertProduct(Map<String, dynamic> product) async {
    Database db = await instance.database;
    return await db.insert('product', product);
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    Database db = await instance.database;
    return await db.query('product');
  }

  Future<int> updateProduct(Map<String, dynamic> product, int id) async {
    Database db = await instance.database;
    return await db.update(
      'product',
      product,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteProduct(int id) async {
    Database db = await instance.database;
    return await db.delete(
      'product',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
