import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/db/dbmodel.dart';

class Orderdetailscreen extends StatefulWidget {
  final Order order;
  final List<OrderDetails> orderDetails;

  const Orderdetailscreen({
    super.key,
    required this.order,
    required this.orderDetails,
  });

  @override
  State<Orderdetailscreen> createState() => _OrderdetailscreenState();
}

class _OrderdetailscreenState extends State<Orderdetailscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Order Details"),
        ),
        body: buildBody());
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildOrderInformation(),
          buildItemList(),
          buildDeliveryInformation()
        ],
      ),
    );
  }

  Widget buildDeliveryInformation() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        // height: 220,
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset("assets/Delivery Scooter@3x.png",
                        width: 40, height: 40),
                    SizedBox(width: 10),
                    Text(
                      "Delivery Information",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivery Address : ",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "# ${widget.orderDetails.first.deliveryLocation}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Delivery Time  : ",
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                    Text(
                      DateFormat("dd MMMM yyyy hh:mm:ss")
                          .format(widget.order.datetime),
                      style: TextStyle(color: Colors.green, fontSize: 16),
                    ),
                  ],
                ),
                                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Payment Method : ",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        " ${widget.orderDetails.first.paymentMethod}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOrderInformation() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        height: 220,
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset("assets/Purchase Order@2x.png",
                        width: 40, height: 40),
                    SizedBox(width: 10),
                    Text(
                      "Order Information",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text(
                      "Invoice   : ",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      "# ${widget.order.id}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Status    : ",
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                    Text(
                      widget.order.status,
                      style: TextStyle(color: Colors.green, fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Total      : ",
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                    Text(
                      "\$ ${widget.order.price}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Cantact : ",
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                    Text(
                      " ${widget.orderDetails.first.contactNumber}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Cupon   : ",
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                    widget.orderDetails.first.cupon == "Enter your cupon code"
                        ? Text("No cupon discount",
                            style: TextStyle(fontSize: 16))
                        : Text(
                            widget.orderDetails.first.cupon,
                            style: TextStyle(fontSize: 16),
                          )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItemList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Card(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsetsDirectional.all(15),
                child: Row(
                  children: [
                    Icon(
                      Icons.production_quantity_limits_sharp,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Product Order",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )),
            Divider(),
            ...widget.orderDetails.map((orderDetail) {
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
                subtitle: Text("X${orderDetail.qtyproduct}"),
                trailing: Text("\$ ${orderDetail.productprice}",style: TextStyle(fontSize: 16),),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
