import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/listproduct.dart';

class DetailproductLogic {
  static Future<void> saveCartItems(Cart cart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartData = jsonEncode(cart.toJson());
    await prefs.setString('cart2', cartData);
  }

  static Future<void> removeCartItem(String productName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart2');
    if (cartData != null) {
      Cart cart = Cart.fromJson(jsonDecode(cartData));
      cart.items.removeWhere((item) => item.name == productName);
      await saveCartItems(cart);
    }
  }

  static Future<Cart> loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart2');
    if (cartData != null) {
      return Cart.fromJson(jsonDecode(cartData));
    }
    return Cart(items: []);
  }
}
