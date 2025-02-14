// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Order {
  final String id;
  final String status;
  final DateTime datetime;
  final String name;
  final String price;
  final int userid;

  Order({
    required this.id,
    required this.status,
    required this.datetime,
    required this.name,
    required this.price,
    required this.userid,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'datetime': datetime.toIso8601String(),
      'name': name,
      'price': price,
      'userid': userid
    };
  }

  static Future<Database> get database async {
    return openDatabase(
      join(await getDatabasesPath(), 'orders_database.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE orders(id TEXT PRIMARY KEY, status TEXT, datetime TEXT, name TEXT, price TEXT,userid INTEGER)',
        );
        db.execute(
          'CREATE TABLE orderdetails(id TEXT PRIMARY KEY, idproduct INTEGER, productname TEXT, productprice TEXT, qtyproduct INTEGER, image TEXT, order_id TEXT,userid INTEGER, FOREIGN KEY(order_id) REFERENCES orders(id) ON DELETE CASCADE)',
        );
      },
      version: 3,
    );
  }

  Future<void> updateStatus(String newStatus) async {
    final db = await Order.database;
    await db.update('orders', {'status': newStatus},
        where: 'id=?', whereArgs: [id]);
  }

  Future<void> saveToDatabase() async {
    final db = await Order.database;
    await db.insert('orders', toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

class OrderDetails {
  final String id;
  final int idproduct;
  final String productname;
  final String productprice;
  final int qtyproduct;
  final String image; // Add the image field
  final String orderId;
  final int userid;

  OrderDetails({
    required this.id,
    required this.idproduct,
    required this.productname,
    required this.productprice,
    required this.qtyproduct,
    required this.image,
    required this.orderId,
    required this.userid,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idproduct': idproduct,
      'productname': productname,
      'productprice': productprice,
      'qtyproduct': qtyproduct,
      'image': image, // Add the image field
      'order_id': orderId,
      'userid': userid,
    };
  }

  static Future<Database> get database async {
    return openDatabase(
      join(await getDatabasesPath(), 'orders_database.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE orders(id TEXT PRIMARY KEY, status TEXT, datetime TEXT, name TEXT, price TEXT,userid INTERGER)',
        );
        db.execute(
          'CREATE TABLE orderdetails(id TEXT PRIMARY KEY, idproduct INTEGER, productname TEXT, productprice TEXT, qtyproduct INTEGER, image TEXT, order_id TEXT, userid INTEGER,FOREIGN KEY(order_id) REFERENCES orders(id) ON DELETE CASCADE)',
        );
      },
      version: 3,
    );
  }

  Future<void> saveToDatabase() async {
    final db = await OrderDetails.database;
    await db.insert('orderdetails', toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
