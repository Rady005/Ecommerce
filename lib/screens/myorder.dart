import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/db/dbmodel.dart';
import '../routes/routes.dart'; // Import the Order model

class Myorder extends StatefulWidget {
  const Myorder({super.key});

  @override
  State<Myorder> createState() => _MyorderState();
}

class _MyorderState extends State<Myorder> {
  Future<List<Order>> fetchOrders() async {
    final db = await Order.database;
    final List<Map<String, dynamic>> maps = await db.query('orders');

    return List.generate(maps.length, (i) {
      return Order(
        id: maps[i]['id'] ?? '',
        status: maps[i]['status'] ?? 'Unknown',
        datetime: maps[i]['datetime'] != null
            ? DateTime.parse(maps[i]['datetime'])
            : DateTime.now(),
        image: maps[i]['image'] ?? '',
        name: maps[i]['name'] ?? 'Unknown',
        price: maps[i]['price'] ?? '0',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(
            context, (route) => route.settings.name == Routes.mains);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Order"),
        ),
        body: FutureBuilder<List<Order>>(
          future: fetchOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No orders found'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final order = snapshot.data![index];
                  return Card(
                    elevation: 6,
                    child: ListTile(
                      leading: Image.network(
                          order.image.isNotEmpty
                              ? "http:${order.image}"
                              : 'https://via.placeholder.com/50',
                          width: 50,
                          height: 50),
                      title: Text("# ${order.id}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Price: ${order.price}"),
                          Text("Status: ${order.status}"),
                          Text(
                              "Date: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(order.datetime)}"),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
