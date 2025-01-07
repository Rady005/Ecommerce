import 'package:assigmentflutterone/screens/detailprodcts.dart';
import 'package:assigmentflutterone/screens/mainscreen.dart';
import 'package:assigmentflutterone/screens/orderscreen.dart';
import 'package:flutter/material.dart';


import 'routes/routes.dart';
import 'screens/category.dart';
import 'screens/chartsrceen.dart';
import 'screens/homescreen.dart';
import 'screens/map_screen.dart';
import 'screens/payment.dart';
import 'screens/searchsrceen.dart';

void main() {
  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.mains,
      routes: {
        Routes.home: (context) => const Homescreen(),
        Routes.addtochart: (context) => const MyCart(),
        Routes.blush: (context) => const Category(),
        Routes.productDetails: (context) => const ProductDetails(),
        Routes.order: (context) => const OrderScreen(),
        Routes.payment: (context) => const PaymentScreen(),
        Routes.map: (context) => const MapScreen(),
        Routes.mains: (contexst) => const Mainscreen(),
        Routes.search: (context) => const Searchsrceen(),
      },
    );
  }
}
