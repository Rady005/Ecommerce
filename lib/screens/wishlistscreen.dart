import 'package:flutter/material.dart';

import '../models/wishlist.dart';

class Wishlistscreen extends StatefulWidget {
  const Wishlistscreen({super.key});

  @override
  State<Wishlistscreen> createState() => _WishlistscreenState();
}

class _WishlistscreenState extends State<Wishlistscreen> {
  final wish = WishList();

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    await wish.loadWishList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Favorite",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
        elevation: 3,
      ),
      body: wish.wishList.isEmpty
          ? Center(
              child: Image.asset(width: 200, height: 200, "assets/empty.jpg"))
          : ListView.builder(
              itemCount: wish.wishList.length,
              itemBuilder: (context, index) {
                var product = wish.wishList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      leading: Image.network("http:${product.image}"),
                      title: Text(product.name),
                      subtitle: Text("${product.priceSign} ${product.price}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite),
                        onPressed: () async {
                          await wish.removeProductFromWishList(product);
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
