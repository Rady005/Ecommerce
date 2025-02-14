import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/db/dbloginmodel.dart';
import '../models/db/dbmodel.dart';
import '../routes/routes.dart'; // Import the Order model

class Myorder extends StatefulWidget {
  const Myorder({super.key});

  @override
  State<Myorder> createState() => _MyorderState();
}

class _MyorderState extends State<Myorder> {
  final ScrollController _scrollController = ScrollController();
  int user_id = 0;
  void getID() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var storeUsername = prefs.getString("user") ?? "users";
      var data = await LoginHelper.getUserDetails(storeUsername);
      if (data != null) {
        setState(() {
          user_id = data["user_id"];
        });
      } else {
        print("User not found");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

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
        userid: maps[i]['userid'] ?? 0,
      );
    });
  }

  Future<List<OrderDetails>> fetchOrderDetails(
      String orderId, int userId) async {
    final db = await OrderDetails.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'orderdetails',
      where: 'order_id = ? AND userid = ?',
      whereArgs: [orderId, userId],
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
        userid: user_id,
      );
    });
  }

  void showOrderDetails(
      BuildContext context, Order order, List<OrderDetails> orderDetails) {
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
                Text(
                    "Date: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(order.datetime)}"),
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
                    trailing: Text("\$ ${orderDetail.productprice}"),
                  );
                }),
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
  void initState() {
    super.initState();
    print("userID : $user_id");
    getID();
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
        title: Text("My Order", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                fetchOrders();
              });
            },
          ),
        ],
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
            // Reverse the order list to show the latest orders at the top
            final orders = snapshot.data!.reversed.toList();

            return ListView.builder(
              controller: _scrollController,
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return FutureBuilder<List<OrderDetails>>(
                  future: fetchOrderDetails(order.id, user_id),
                  builder: (context, detailsSnapshot) {
                    if (detailsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (detailsSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${detailsSnapshot.error}'));
                    } else if (!detailsSnapshot.hasData 
                        ) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Image.asset(
                                width: 200, height: 200, "assets/empty.jpg")),
                      );
                    } else if (user_id == order.userid) {
                      return InkWell(
                        onTap: () {
                          showOrderDetails(
                              context, order, detailsSnapshot.data!);
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
                                    Text("# ${order.id}",
                                        style: TextStyle(fontSize: 16)),
                                    Text(order.userid.toString()),
                                    Text(" \$ ${order.price}",
                                        style: TextStyle(fontSize: 16)),
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
                                      style: order.status == "Process"
                                          ? TextStyle(color: Colors.amberAccent)
                                          : TextStyle(color: Colors.green),
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
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.green),
                                      ),
                                      child: Text("Order Details",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return SizedBox
                        .shrink(); // <-- Ensures a widget is always returned
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
