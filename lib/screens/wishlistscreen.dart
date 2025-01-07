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
      appBar: AppBar(),
      body: wish.wishList.isEmpty
          ? Center(
              child: Image.asset(width: 200, height: 200, "assets/empty.jpg"))
          : ListView.builder(
              itemCount: wish.wishList.length,
              itemBuilder: (context, index) {
                var product = wish.wishList[index];
                return ListTile(
                  leading: Image.network("http:${product.image}"),
                  title: Text(product.name),
                  subtitle: Text("${product.priceSign} ${product.price}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await wish.removeProductFromWishList(product);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
    );
  }


  
}
