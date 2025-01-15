
import 'package:shared_preferences/shared_preferences.dart';

import '../models/allitemdisplay.dart';


class OrderLogic {
  
  static Future<void> loadPreferences(Function setStateCallback) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setStateCallback((String phonenumber, String location) {
      location = prefs.getString('location') ?? "Select your Location";
      phonenumber = prefs.getString('phonenumber') ?? "Enter your phone number";
    });
  }

  static Future<void> savePreferences(
      String location, String phonenumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('location', location);
    await prefs.setString('phonenumber', phonenumber);
  }

   void calculateTotal(
      List<Map<String, dynamic>> cart,
      List<Map<String, dynamic>> coupons,
      String cupon,
      Function setStateCallback) {
    double price = 0.0;
    for (var item in cart) {
      price += (item['product'] as Product).priceAskdouble * item['quantity'];
    }
    applyDiscount(price, coupons, cupon, setStateCallback);
  }

  static void applyDiscount(double price, List<Map<String, dynamic>> coupons,
      String cupon, Function setStateCallback) {
    double discount = 0;
    for (var coupon in coupons) {
      if (coupon['code'] == cupon) {
        discount = price * (coupon['value'] / 100);
        break;
      }
    }
    setStateCallback(() {
      price -= discount;
    });
  }


}
