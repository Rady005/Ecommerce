
import 'package:flutter/material.dart';


import '../models/allitemdisplay.dart';
import '../routes/routes.dart';
import '../widgets/coupon.dart';
import '../widgets/modelbottomsheet.dart';
import 'map_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String location = "None";
  String phonenumber = "None";
  double price = 0;
  List<Map<String, dynamic>> cart = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments
        as List<Map<String, dynamic>>;
    if (arguments != null) {
      setState(() {
        cart = arguments;
        _calculateTotal();
      });
    }
  }

  void _calculateTotal() {
    price = 0.0;
    for (var item in cart) {
      price += (item['product'] as Product).priceAskdouble * item['quantity'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                children: [
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
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      pushPaymentScreen(context);
                    },
                    child: buildwithImage("assets/debit/cash 1@2x.png",
                        "Payment", "Cash on Delivery"),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                
                    child: ListView.builder(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Price: ${product.priceSign} ${product.price}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600]),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Color: ${item['color']}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        setState(() {
                                          if (item['quantity'] > 1) {
                                            item['quantity']--;
                                          }
                                          _calculateTotal();
                                        });
                                      },
                                    ),
                                    Text(
                                      "$quantity",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          item['quantity']++;
                                          _calculateTotal();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      genderModalDailogCoupon();
                    },
                    child: buildwithImage("assets/Voucher@3x.png", "Coupon",
                        "Enter Coupon to get Discount"),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  _buildOrderSummary(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "\$ $price",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder()),
                    child: const Text(
                      "PLACE ORDER",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            )
          ],
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
    return Expanded(
      child: Card(
        elevation: 4,
        child: SizedBox(
          height: 70,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              )
            ]),
          ),
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
            Text("USD $price", style: TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Discount", style: TextStyle(fontSize: 16)),
            Text("-", style: TextStyle(fontSize: 16)),
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
              "\$ $price",
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
          builder: (context) => const MapScreen()), // Navigate to MapScreen.
    );

    if (selectedAddress is String) {
      setState(() {
        location =
            selectedAddress; // Update the location variable with the returned address.
      });
    }
  }

  void showModalClick() async {
    var result = await ContactNumberModalDailog.show(context);
    if (result is String) {
      setState(() {
        phonenumber = result;
      });
    }
  }

  void genderModalDailogCoupon() async {
    var result = await CouponModalDailog.show(context);
    if (result is String) {
      setState(() {});
    }
  }
}
