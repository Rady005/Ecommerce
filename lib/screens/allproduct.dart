import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:shimmer/shimmer.dart';

import '../models/allitemdisplay.dart';
import '../routes/routes.dart';

class AllProduct extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  const AllProduct({super.key, required this.products});

  @override
  State<AllProduct> createState() => _AllProductState();
}

class _AllProductState extends State<AllProduct> {
  static const int initialProductCount = 20;
  List<Map<String, dynamic>> displayedProducts = [];
  int currentProductCount = initialProductCount;

  @override
  void initState() {
    super.initState();
    loadInitialProducts();
  }

  void loadInitialProducts() {
    setState(() {
      displayedProducts = widget.products.take(initialProductCount).toList();
    });
  }

  void loadMoreProducts() {
    setState(() {
      currentProductCount += initialProductCount;
      displayedProducts = widget.products.take(currentProductCount).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: widget.products.length,
          itemBuilder: (BuildContext context, int index) {
            var item = widget.products[index];
            var product = Product.fromJson(item);
            return Bounceable(
              onTap: () {
                detailScreenClick(context, product);
              },
              child: Card(
                color: Colors.white,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          "http:${product.image}",
                          fit: BoxFit.cover,
                          width: double.infinity,
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
                      const SizedBox(height: 5),
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        product.description,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Price: ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text:
                                  product.priceSign + product.price.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        if (currentProductCount < widget.products.length)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: loadMoreProducts,
              child: Text('View More'),
            ),
          ),
      ],
    );
  }
}

void detailScreenClick(BuildContext context, Product product) async {
  Navigator.pushNamed(context, Routes.productDetails, arguments: product);
}
