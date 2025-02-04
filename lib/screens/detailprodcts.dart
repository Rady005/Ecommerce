import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../models/allitemdisplay.dart';
import '../models/wishlist.dart';
import '../routes/routes.dart';
import 'widgets/cartservice.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final wish = WishList();
  bool isFav = false;

  void addToCart(Product product) async {
    final cartService = CartService();
    bool isProductInCart = false;

    List<Map<String, dynamic>> cart = await cartService.getCart();

    for (var cartItem in cart) {
      var existingProduct = Product.fromJson(cartItem['product']);
      if (existingProduct.name == product.name &&
          existingProduct.price == product.price &&
          existingProduct.image == product.image) {
        setState(() {
          cartItem['quantity']++;
        });
        isProductInCart = true;
        break;
      }
    }

    if (!isProductInCart) {
      setState(() {
        cart.add({
          'product': product.toJson(),
          'quantity': 1,
          'color': colornameProduct,
        });
      });
    }
    await cartService.saveCart(cart);

    setState(() {});
  }

  int selectedColorIndex = 0;
  int qty = 0;
  String colornameProduct = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var productDS = ModalRoute.of(context)?.settings.arguments as Product;
    setState(() {
      colornameProduct = productDS.productColors.isNotEmpty
          ? productDS.productColors[0].colorName
          : "No Color ";
    });
    _checkIfFavorite(productDS);
  }

  Future<void> _checkIfFavorite(Product product) async {
    await wish.loadWishList();
    setState(() {
      isFav = wish.wishList.any((item) => item.name == product.name);
    });
  }

  void buildItemfromBuynow(Product product) {
    List<Map<String, dynamic>> selectedItems = [
      {
        'product': product,
        'quantity': 1,
        'color': colornameProduct,
      }
    ];
    Navigator.pushNamed(
      context,
      Routes.order,
      arguments: selectedItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    var productDs = ModalRoute.of(context)!.settings.arguments as Product;
    List<Map<String, dynamic>> cart = [];
    var textStyle = const TextStyle(
      fontSize: 18,
      color: Colors.red,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () async {

                    Navigator.pushNamed(
                      context,
                      Routes.addtochart,
                      arguments: cart,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: SvgPicture.asset("assets/svg/cart 02.svg"),
                    ),
                  ),
                ),
                // Positioned(
                //   right: 5,
                //   child: Container(
                //     padding: const EdgeInsets.all(2),
                //     decoration: const BoxDecoration(
                //       color: Colors.red,
                //       shape: BoxShape.circle,
                //     ),
                //     constraints: const BoxConstraints(
                //       minWidth: 16,
                //       minHeight: 16,
                //     ),
                //     // child: Text(
                //     //   cart.length.toString(),
                //     //   style: const TextStyle(
                //     //     color: Colors.white,
                //     //     fontSize: 12,
                //     //   ),
                //     //   textAlign: TextAlign.center,
                //     // ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  "http:${productDs.image}",
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productDs.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Price: ${productDs.priceSign} ${productDs.price}",
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        isFav = !isFav;
                      });
                      if (isFav) {
                        await wish.addProductToWishList(productDs);
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.success(
                            message: "Add to Wishlist successfully.",
                          ),
                        );
                      } else {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.error(
                            message: "Add to Wishlist successfully.",
                          ),
                        );
                        await wish.removeProductFromWishList(productDs);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: SvgPicture.asset(
                        isFav
                            ? "assets/svg/love_solid.svg"
                            : "assets/svg/love.svg",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Color: $colornameProduct',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  productDs.productColors.isNotEmpty
                      ? SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: productDs.productColors.length,
                            itemBuilder: (context, index) {
                              var colorData = productDs.productColors[index];
                              var isSelected =
                                  colornameProduct == colorData.colorName;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    colornameProduct = colorData.colorName;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(colorData.hexValue
                                        .replaceFirst('#', '0xFF'))),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : const Text(
                          "No colors available",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Description",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                productDs.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    qty += 1;
                  });
                  addToCart(productDs);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: ElevatedButton(
                  onPressed: () {
                    buildItemfromBuynow(productDs);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    "BUY NOW",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
