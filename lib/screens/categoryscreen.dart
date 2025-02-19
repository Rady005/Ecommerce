import 'package:flutter/material.dart';

import '../models/allitemdisplay.dart';
import '../routes/routes.dart';

class Categoryscreen extends StatefulWidget {
  const Categoryscreen({super.key});

  @override
  State<Categoryscreen> createState() => _CategoryscreenState();
}

class _CategoryscreenState extends State<Categoryscreen> {
  @override
  Widget build(BuildContext context) {
    var filteredProducts = ModalRoute.of(context)?.settings.arguments
        as List<Map<String, dynamic>>;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product",
          style: TextStyle(fontSize: 25, color: Colors.white),
          
        ),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: filteredProducts.isEmpty
          ? const Center(
              child: Text(
                "Product Unavialable",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                var product = Product.fromJson(filteredProducts[index]);

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.productDetails,
                      arguments: product,
                    );
                  },
                  child: Card(
                    elevation: 6,
                    shadowColor: Colors.grey,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                  image: NetworkImage("http:${product.image}"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              product.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Text(
                              "Price: ${product.priceSign}${product.price}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
