import 'package:assigmentflutterone/screens/categoryscreen.dart';
import 'package:assigmentflutterone/screens/detailprodcts.dart';
import 'package:assigmentflutterone/screens/loginscreen.dart';
import 'package:assigmentflutterone/screens/mainscreen.dart';
import 'package:assigmentflutterone/screens/orderscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes/routes.dart';
import 'screens/chartsrceen.dart';
import 'screens/detailocation.dart';
import 'screens/homescreen.dart';
import 'screens/map_screen.dart';
import 'screens/myorder.dart';
import 'screens/payment.dart';
import 'screens/register.dart';
import 'screens/searchsrceen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isRegistered = prefs.getBool('isRegistered') ?? false;
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
 

  runApp(MainApp(isRegistered: isRegistered, isLoggedIn: isLoggedIn));
}

class MainApp extends StatelessWidget {
  final bool isRegistered;
  final bool isLoggedIn;
  const MainApp(
      {super.key, required this.isRegistered, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isRegistered || 
      isLoggedIn ? Routes.mains : Routes.login,
      routes: {
        Routes.home: (context) => const Homescreen(),
        Routes.addtochart: (context) => const MyCart(),
        Routes.blush: (context) => const Categoryscreen(),
        Routes.productDetails: (context) => const ProductDetails(),
        Routes.order: (context) => const OrderScreen(),
        Routes.payment: (context) => const PaymentScreen(),
        Routes.map: (context) => const MapScreen(),
        Routes.mains: (context) => const Mainscreen(),
        Routes.search: (context) => const Searchsrceen(),
        Routes.detaillocation: (context) => const Detailocation(),
        Routes.login: (context) => const Loginscreen(),
        Routes.myorder: (context) => Myorder(),
        Routes.register: (context) => RegisterScreen()
      },
    );
  }
}
