

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
        name: maps[i]['name'] ?? 'Unknown',
        price: maps[i]['price'] ?? '0',
      );
    });
  }

  Future<List<OrderDetails>> fetchOrderDetails(String orderId) async {
    final db = await OrderDetails.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'orderdetails',
      where: 'order_id = ?',
      whereArgs: [orderId],
    );

    return List.generate(maps.length, (i) {
      return OrderDetails(
        id: maps[i]['id'] ?? '',
        idproduct: maps[i]['idproduct'] ?? 0,
        productname: maps[i]['productname'] ?? 'Unknown',
        productprice: maps[i]['productprice'] ?? '0',
        qtyproduct: maps[i]['qtyproduct'] ?? 0,
        image: maps[i]['image'] ?? '',
        orderId: maps[i]['order_id'] ?? '',
      );
    });
  }

  void showOrderDetails(BuildContext context, Order order, List<OrderDetails> orderDetails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Order Details"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order ID: ${order.id}"),
                Text("Status: ${order.status}"),
                Text("Date: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(order.datetime)}"),
                Text("Total Price: \$${order.price}"),
                Divider(),
                Text("Products:"),
                ...orderDetails.map((orderDetail) {
                  return ListTile(
                    leading: Image.network(
                      orderDetail.image.startsWith('http')
                          ? orderDetail.image
                          : "http:${orderDetail.image}",
                      width: 60,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 50,
                          color: Colors.grey,
                          child: Icon(Icons.image_not_supported),
                        );
                      },
                    ),
                    title: Text(orderDetail.productname),
                    subtitle: Text("Quantity: ${orderDetail.qtyproduct}"),
                    trailing: Text("\$${orderDetail.productprice}"),
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
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
          elevation: 3,
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
                reverse: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final order = snapshot.data![index];
                  return FutureBuilder<List<OrderDetails>>(
                    future: fetchOrderDetails(order.id),
                    builder: (context, detailsSnapshot) {
                      if (detailsSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (detailsSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${detailsSnapshot.error}'));
                      } else if (!detailsSnapshot.hasData ||
                          detailsSnapshot.data!.isEmpty) {
                        return Center(child: Text('No order details found'));
                      } else {
                        return InkWell(
                          onTap: () {
                            showOrderDetails(context, order, detailsSnapshot.data!);
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 6,
                            margin: EdgeInsets.all(10),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "# ${order.id}",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        " \$ ${order.price}", // Display the calculated price
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        style: TextStyle(fontSize: 16),
                                        "Date: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(order.datetime)}",
                                      ),
                                      Spacer(),
                                      Text(
                                        " ${order.status}",
                                        style: TextStyle(
                                            color: Colors.amberAccent,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Wrap(
                                      children: detailsSnapshot.data!
                                          .map((orderDetail) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Image.network(
                                            orderDetail.image.startsWith('http')
                                                ? orderDetail.image
                                                : "http:${orderDetail.image}",
                                            width: 60,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                width: 60,
                                                height: 50,
                                                color: Colors.grey,
                                                child: Icon(
                                                    Icons.image_not_supported),
                                              );
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
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