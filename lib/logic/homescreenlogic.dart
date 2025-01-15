import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/listproduct.dart';

class Homescreenlogic {
    Future<Cart?> loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart2');
    if (cartData != null) {
      return Cart.fromJson(jsonDecode(cartData));
    }
    return null;
  }
}
