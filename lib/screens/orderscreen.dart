import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../widgets/coupon.dart';
import '../../widgets/modelbottomsheet.dart';
import '../models/allitemdisplay.dart';
import '../models/cupon.dart';
import '../models/db/dbmodel.dart';
import '../routes/routes.dart';
import 'map_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String location = "Select your Location";
  String phonenumber = "Enter your phone number";
  String cupon = "Enter your cupon code";
  double price = 0;
  double discount = 0;
  List<Map<String, dynamic>> cart = [];
  List<Map<String, dynamic>> buynow = [];
  bool isplaceorder = false;
  String buttonState = "PLACE ORDER";
  String displayPrice = "";
  String process = "Process";
  String datatime = "";
  bool isshow = false;
  String orderId = "";

  Future<void> saveOrder(
      List<Map<String, dynamic>> cart, String invoiceId) async {
    var now = DateTime.now();
    // final formattedDateTime = DateFormat('yyyyMMddHHmmsss').format(now);

    // Calculate the total price for the entire order
    double totalPrice = 0;
    for (var item in cart) {
      var product = item['product'] as Product;
      var quantity = item['quantity'];
      totalPrice += product.priceAskdouble * quantity;
    }
    setState(() {
      orderId = invoiceId;
    });
    final order = Order(
      id: invoiceId,
      status: process,
      datetime: now,
      name: ' $invoiceId',
      price: totalPrice.toString(), // Use the calculated total price
    );

    await order.saveToDatabase();

    for (var i = 0; i < cart.length; i++) {
      var product = cart[i]['product'] as Product;
      var quantity = cart[i]['quantity'];
      var imgList = product.image;

      // Split the image list if it contains multiple URLs
      List<String> imageUrls = imgList.split(',');

      for (var j = 0; j < imageUrls.length; j++) {
        final orderDetails = OrderDetails(
          id: '$invoiceId-$i-$j', // Generate a unique id for each entry
          idproduct: product.id,
          productname: product.name,
          productprice: product.price.toString(),
          qtyproduct: quantity,
          image: imageUrls[j].trim(), // Use the individual image URL
          orderId: order.id,
        );

        // print("imageURL: ${imageUrls[j].trim()}");
        await orderDetails.saveToDatabase();
      }
    }
  }

  Future<void> updateStatus(String id, String status) async {
    final db = await Order.database;
    await db.update(
      'orders',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  void placeOrder() {
    var invoiceId = DateFormat('yyyyMMddHHmmsss').format(DateTime.now());
    saveOrder(cart, invoiceId);
    // Optionally, clear the cart after placing the order

  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments
        as List<Map<String, dynamic>>;
    setState(() {
      cart = arguments;
      _calculateTotal();
    });
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      location = prefs.getString('location') ?? "Select your Location";
      phonenumber = prefs.getString('phonenumber') ?? "Enter your phone number";
    });
  }

  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('location', location);
    await prefs.setString('phonenumber', phonenumber);
  }

  void _calculateTotal() {
    price = 0.0;
    for (var item in cart) {
      price += (item['product'] as Product).priceAskdouble * item['quantity'];
    }
    _applyDiscount();
  }

  void _applyDiscount() {
    discount = 0;
    for (var coupon in coupons) {
      if (coupon['code'] == cupon) {
        discount = price * (coupon['value'] / 100);
        break;
      }
    }
    setState(() {
      price -= discount;
      displayPrice = "\$ ${price.toStringAsFixed(2)}"; // Update display price
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                children: <Widget>[
                  buildshow(),
                  GestureDetector(
                    onTap: () {
                      pushMapscreen(context);
                    },
                    child: buildwithImage("assets/Delivery Scooter@3x.png",
                        "Delivery Location", location),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      showModalClick();
                    },
                    child: buildwithImage(
                        "assets/Phone@2x.png", "Contact Number", phonenumber),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      pushPaymentScreen(context);
                    },
                    child: buildwithImage("assets/debit/cash 1@2x.png",
                        "Payment", "Cash on Delivery"),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  buildItemfromCart(),
                  const Divider(),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      genderModalDailogCoupon();
                    },
                    child: buildwithImage(
                        "assets/Voucher@3x.png", "Coupon", cupon),
                  ),
                  const Divider(),
                  cart.isEmpty ? const Text("No product") : buildItem(),
                  const Divider(),
                  _buildOrderSummary(),
                  const Divider(),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: builddisplaystuts(),
                ),
                buildActionButton(),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget builddisplaystuts() {
    if (isshow == true) {
      return buildproces();
    }
    return Text(
      "\$ ${price.toStringAsFixed(2)}",
      style: TextStyle(fontSize: 16),
    );
  }

  Widget buildproces() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [buildStauts(), Text(datatime)],
    );
  }

  Widget buildshow() {
    if (isshow == false) {
      return buildEmptycontainer();
    }

    return buildwaitingstatus();
  }

  Widget buildActionButton() {
    switch (buttonState) {
      case "PLACE ORDER":
        return buildPlaceOrder();
      case "MARK AS RECEIVED":
        return buildMarkAsReceived();
      case "COMPLETE":
        return buildComplete();
      default:
        return buildPlaceOrder();
    }
  }

  Widget buildComplete() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: ElevatedButton(
        onPressed: () async {
          print(orderId);
          // await updateStatus(orderId, "Complete");
          QuickAlert.show(
              context: context,
              barrierDismissible: false,
              type: QuickAlertType.success,
              text: 'Buy Completed Successfully!',
              onConfirmBtnTap: () {
                Navigator.pushNamed(context, Routes.myorder);
              });
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
            shape: RoundedRectangleBorder()),
        child: const Text(
          "COMPLETE",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  // Widget buildComplete() {
  //   return SizedBox(
  //     width: MediaQuery.of(context).size.width / 2,
  //     child: ElevatedButton(
  //       onPressed: () async {
  //         await updateStatus(orderId,"Complete");
  //         isshow = false;
  //         QuickAlert.show(
  //             context: context,
  //             barrierDismissible: false,
  //             type: QuickAlertType.success,
  //             text: 'Buy  Completed Successfully!',
  //             onConfirmBtnTap: () {
  //               Navigator.pushNamed(context, Routes.myorder);
  //             });
  //       },
  //       style: ElevatedButton.styleFrom(
  //           backgroundColor: Colors.green,
  //           padding: const EdgeInsets.symmetric(vertical: 16),
  //           textStyle: const TextStyle(fontSize: 18),
  //           shape: RoundedRectangleBorder()),
  //       child: const Text(
  //         "COMPLETE",
  //         style: TextStyle(color: Colors.white, fontSize: 18),
  //       ),
  //     ),
  //   );
  // }

  // Widget buildMarkAsReceived() {
  //   return SizedBox(
  //     width: MediaQuery.of(context).size.width / 2,
  //     child: ElevatedButton(
  //       onPressed: () {
  //         setState(() {
  //           isshow = false;
  //           buttonState = "COMPLETE";
  //           process = "Complete";
  //           datatime =
  //               "${DateFormat('h:mm a dd MMM yyyy').format(DateTime.now())} ";
  //         });
  //       },
  //       style: ElevatedButton.styleFrom(
  //           backgroundColor: Colors.white,
  //           padding: const EdgeInsets.symmetric(vertical: 16),
  //           textStyle: const TextStyle(fontSize: 18),
  //           side: BorderSide(color: Colors.black, width: 2),
  //           shape: RoundedRectangleBorder()),
  //       child: const Text(
  //         "MARK AS RECEIVED",
  //         style: TextStyle(color: Colors.black, fontSize: 18),
  //       ),
  //     ),
  //   );
  // }
  Widget buildMarkAsReceived() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: ElevatedButton(
        onPressed: () async {
          print("ordxer id ${orderId}");
          await updateStatus(orderId, "Complete");
          setState(() {
            isshow = false;
            buttonState = "COMPLETE";
            process = "Complete";
            datatime =
                "${DateFormat('h:mm a dd MMM yyyy').format(DateTime.now())} ";
          });
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
            side: BorderSide(color: Colors.black, width: 2),
            shape: RoundedRectangleBorder()),
        child: const Text(
          "MARK AS RECEIVED",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }

  Widget buildPlaceOrder() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: ElevatedButton(
        onPressed: () {
          isshow = true;
          _savePreferences();
          placeOrder();

          

          setState(() {
            // cart.removeWhere((item)=>item['selected']==true);

            buttonState = "MARK AS RECEIVED";
            datatime =
                "${DateFormat('h:mm a dd MMM yyyy').format(DateTime.now())} ";
          });
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
            side: BorderSide(
              color: Colors.black,
            ),
            shape: RoundedRectangleBorder()),
        child: const Text(
          "PLACE ORDER",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  Widget buildItem() {
    return SizedBox(
      height: 70,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(children: [
            Image.asset("assets/Purchase Order@2x.png", width: 40, height: 40),
            const SizedBox(width: 5),
            Text(
              "Order Summary",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(width: 5),
            Text(
              "(${cart.length} items)",
              style: TextStyle(color: Colors.black),
            ),
          ]),
        ),
      ),
    );
  }

  Widget buildOrder(String imglocal, String text1, String text2) {
    return Row(children: [
      Image.asset(imglocal, width: 40, height: 40),
      const SizedBox(width: 16),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(text1),
        Spacer(),
        Text(text2),
      ])
    ]);
  }

  Widget buildwithImage(String imglocation, String text1, String text2) {
    return Card(
      elevation: 2,
      child: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(children: [
            Image.asset(
              imglocation,
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text1,
                    style: TextStyle(fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(text2,
                      style: TextStyle(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Subtotal", style: TextStyle(fontSize: 16)),
            Text("\$ ${(price + discount).toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Discount", style: TextStyle(fontSize: 16)),
            Text("\$ ${discount.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "\$ ${price.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  void pushPaymentScreen(BuildContext context) {
    Navigator.pushNamed(context, Routes.payment);
  }

  void pushMapscreen(BuildContext context) async {
    final selectedAddress = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
      ),
    );

    if (selectedAddress is String) {
      setState(() {
        location = selectedAddress;
        _savePreferences();
      });
    }
  }

  void showModalClick() async {
    var result = await ContactNumberModalDailog.show(context);
    if (result is String) {
      setState(() {
        phonenumber = result;
        _savePreferences();
      });
    }
  }

  void genderModalDailogCoupon() async {
    var result = await CouponModalDailog.show(context);
    if (result is String) {
      bool isValidCoupon = false;
      for (var coupon in coupons) {
        if (coupon['code'] == result) {
          isValidCoupon = true;
          break;
        }
      }
      if (isValidCoupon) {
        setState(() {
          cupon = result;
          _calculateTotal();
        });
        showTopSnackBar(
          // ignore: use_build_context_synchronously
          Overlay.of(context),
          CustomSnackBar.success(
            message: "Applied Cupon successfully.",
          ),
        );
      } else {
        setState(() {
          cupon = "Enter your cupon code";
        });

        showTopSnackBar(
          // ignore: use_build_context_synchronously
          Overlay.of(context),
          CustomSnackBar.error(
            message: "Invalid Cupon Code!",
          ),
        );
      }
    }
  }

  Widget buildItemfromCart() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cart.length,
      itemBuilder: (context, index) {
        final item = cart[index];
        var product = item['product'] as Product;
        var quantity = item['quantity'];
        return Card(
          elevation: 6,
          child: Container(
            color: Colors.white,
            width: double.infinity,
            height: 100,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Image.network(
                    "http:${product.image}",
                    width: 70,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Price: ${product.priceSign} ${product.price}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Color: ${item['color']}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            item['quantity']++;
                          });
                          _calculateTotal();
                        },
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: Text("+"),
                          ),
                        ),
                      ),
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: Center(child: Text("$quantity")),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            item['quantity']--;
                            if (item['quantity'] == 0) {
                              item['quantity'] = 1;
                            }
                          });
                          _calculateTotal();
                        },
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: Text("-"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildEmptycontainer() {
    return Container(
      height: 1,
      color: Colors.white,
    );
  }

  Widget buildStauts() {
    return Text(
      process,
      style: TextStyle(color: Colors.yellow, fontSize: 18),
    );
  }

  Widget buildwaitingstatus() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        decoration:
            BoxDecoration(shape: BoxShape.rectangle, color: Colors.black),
        child: Center(
          child: Text(
            "We had received your order,our customize service will\n contact you soon.Thnaks for shopping with us.",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
