import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../models/allitemdisplay.dart';
import '../models/selectedlist.dart';
import '../routes/routes.dart';
import 'widgets/cartservice.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  late double screenWidth;
  late double screenHeight;
  List<Map<String, dynamic>> cart = [];
  double price = 0.0;
  int itemCount = 0;
  final selectedList = SelectedList();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCart();
  }

  void _loadCart() async {
    final cartService = CartService();
    final savedCart = await cartService.getCart();

    setState(() {
      cart = _mergeDuplicateProducts(savedCart);
      _calculateTotal();
    });
  }

  List<Map<String, dynamic>> _mergeDuplicateProducts(
      List<Map<String, dynamic>> savedCart) {
    List<Map<String, dynamic>> mergedCart = [];
    for (var item in savedCart) {
      var product = Product.fromJson(item['product']);
      bool isExisting = false;

      for (var mergedItem in mergedCart) {
        if (mergedItem['product'] == product) {
          mergedItem['quantity'] += item['quantity'];
          isExisting = true;
          break;
        }
      }

      if (!isExisting) {
        mergedCart.add({
          'product': product,
          'quantity': item['quantity'],
          'color': item['color'],
          'selected': false, // Add selected property
        });
      }
    }
    return mergedCart;
  }

  void _saveCart() {
    final cartService = CartService();
    final serializedCart = cart.map((item) {
      return {
        'product': (item['product'] as Product).toJson(),
        'quantity': item['quantity'],
        'color': item['color'],
        'selected': item['selected'], // Save selected property
      };
    }).toList();
    cartService.saveCart(serializedCart);
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (cart[index]['quantity'] > 1) {
        cart[index]['quantity']--;
      } else {
        cart.removeAt(index);
      }
      _calculateTotal();
    });
    _saveCart();
  }

  void _increaseQuantity(int index) {
    setState(() {
      cart[index]['quantity']++;
      _calculateTotal();
    });
    _saveCart();
  }

  void _calculateTotal() {
    price = 0.0;
    itemCount = 0;
    for (var item in cart) {
      if (item['selected']) {
        price += (item['product'] as Product).priceAskdouble * item['quantity'];
        itemCount += item['quantity'] as int; // Count only selected items
      }
    }
  }

  void _checkout() async {
    List<Map<String, dynamic>> selectedItems = [];
    for (var item in cart) {
      if (item['selected']) {
        selectedItems.add(item);
      }
    }

    if (selectedItems.isEmpty) {
      return;
    } else {
      Navigator.pushNamed(context, Routes.order, arguments: selectedItems);
    }

    // Remove selected items from the cart
    setState(() {
      // cart.removeWhere((item) => item['selected']);
      _calculateTotal();
    });
    _saveCart();
  }

  void _toggleSelection(int index) {
    setState(() {
      cart[index]['selected'] = !cart[index]['selected'];
      _calculateTotal();
    });
    _saveCart();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text("Cart", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: cart.isNotEmpty
          ? Card(
              elevation: 5,
              child: Column(
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: cart.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 12,
                        );
                      },
                      itemBuilder: (context, index) {
                        var cartItem = cart[index];
                        var product = cartItem['product'] as Product;
                        var quantity = cartItem['quantity'];
                        var isSelected = cartItem['selected'];
                        return Bounceable(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.productDetails,
                                arguments: product);
                          },
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 100,
                                  child: Image.network(
                                    "http:${product.image}",
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        "${product.priceSign} ${product.price}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        "Color: ${cartItem['color']}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _toggleSelection(index);
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: SizedBox(
                                            width: 25,
                                            height: 25,
                                            child: SvgPicture.asset(isSelected
                                                ? "assets/svg/Group 67-2.svg"
                                                : "assets/svg/Group 67.svg"),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                _increaseQuantity(index);
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
                                              child: Center(
                                                  child: Text("$quantity")),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _decreaseQuantity(index);
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
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          : Center(
              child: Container(
                color: Colors.white,
                width: 200,
                height: 200,
                child: Image.asset("assets/product-not-found.jpg"),
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.white,
        child: Container(
          color: Colors.white,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  "Total : \$ ${price.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  " Items  : $itemCount",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                )
              ]),
              Spacer(),
              SizedBox(
                width: screenWidth * 0.5,
                child: ElevatedButton(
                  onPressed: cart.isEmpty
                      ? null
                      : () {
                          _checkout();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    "Checkout",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
