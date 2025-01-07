import 'dart:convert';



import 'package:shared_preferences/shared_preferences.dart';

import 'allitemdisplay.dart';

class WishList {
  List<Product> wishList = [];

  // Add product to wishlist and notify listeners
  Future<void> addProductToWishList(Product product) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load existing wishlist
      String? existingWishlistString = prefs.getString('wishlist');
      List<Product> existingWishlist = [];

      if (existingWishlistString != null) {
        List<dynamic> decodedList = jsonDecode(existingWishlistString);
        existingWishlist = decodedList.map((e) => Product.fromJson(e)).toList();
      }

      // Add new product if not already in the list
      if (!existingWishlist.any((item) => item.name == product.name)) {
        existingWishlist.add(product);
      }

      // Save updated wishlist
      await prefs.setString('wishlist', jsonEncode(existingWishlist));

      // Update in-memory wishlist
      wishList = existingWishlist;
    } catch (e) {
      // print("Error adding product to wishlist: $e");
    }
  }

  // Remove product from wishlist
  Future<void> removeProductFromWishList(Product product) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load existing wishlist
      String? existingWishlistString = prefs.getString('wishlist');
      List<Product> existingWishlist = [];

      if (existingWishlistString != null) {
        List<dynamic> decodedList = jsonDecode(existingWishlistString);
        existingWishlist = decodedList.map((e) => Product.fromJson(e)).toList();
      }

      // Remove product if it exists in the list
      existingWishlist.removeWhere((item) => item.name == product.name);

      // Save updated wishlist
      await prefs.setString('wishlist', jsonEncode(existingWishlist));

      // Update in-memory wishlist
      wishList = existingWishlist;
    } catch (e) {
      // print("Error removing product from wishlist: $e");
    }
  }

  Future<void> saveWishList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String updatedWishlistString = jsonEncode(wishList);
      await prefs.setString('wishlist', updatedWishlistString);
    } catch (e) {
      // print("Error saving wishlist: $e");
    }
  }

  Future<void> loadWishList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? wishlistString = prefs.getString('wishlist');
      if (wishlistString != null) {
        List<dynamic> decodedList = jsonDecode(wishlistString);
        wishList = decodedList.map((e) => Product.fromJson(e)).toList();
      } else {
        wishList = [];
      }
    } catch (e) {
      // print("Error loading wishlist: $e");
    }
  }
}