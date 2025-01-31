import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Order {
  final String id;
  final String status;
  final DateTime datetime;
  final String image;
  final String name;
  final String price;

  Order({
    required this.id,
    required this.status,
    required this.datetime,
    required this.image,
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'datetime': datetime.toIso8601String(),
      'image': image,
      'name': name,
      'price': price,
    };
  }

  static Future<Database> get database async {
    return openDatabase(
      join(await getDatabasesPath(), 'orders_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE orders(id TEXT PRIMARY KEY, status TEXT, datetime TEXT, image TEXT, name TEXT, price TEXT)',
        );
      },
      version: 2,
    );
  }

  Future<void> saveToDatabase() async {
    final db = await Order.database;
    await db.insert('orders', toMap(),
        // conflictAlgorithm: ConflictAlgorithm.replace,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
