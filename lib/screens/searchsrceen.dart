// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// import '../models/listproduct.dart';
// import '../models/resource/product_sliver.dart';
// import 'allproduct.dart';
// import 'chartsrceen.dart';

// class Searchsrceen extends StatefulWidget {
//   const Searchsrceen({super.key});

//   @override
//   State<Searchsrceen> createState() => _SearchsrceenState();
// }

// class _SearchsrceenState extends State<Searchsrceen> {
//   TextEditingController searchController = TextEditingController();
//   List<Map<String, dynamic>> filtterItems = [];
//   bool isSearchClick = false;

//   List<Map<String, dynamic>> cart = [];

//   @override
//   void initState() {
//     // searchController.addListener(filtterData);
//     super.initState();
//     filtterItems = products.take(30).toList();

//   }

//   void filtterData() {

//     final query = searchController.text.toLowerCase();
//     final temProducts = products
//         .where((item) => item['name'].toLowerCase().contains(query))
//         .toList();

//     setState(() {
//       filtterItems = temProducts;
//     });
//   }

//   @override
//   void dispose() {
//     // searchController.removeListener(filtterData);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildAppBar(),
//       body: buildBody(),
//     );
//   }

//   AppBar buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       toolbarHeight: 80,
//       automaticallyImplyLeading: false,
//       title: Row(
//         children: [
//           Expanded(child: buildSearchTextField()),
//           SizedBox(width: 5),
//           GestureDetector(
//             onTap: () async {
//               Cart? cart = await loadCartItems();
//               Navigator.push(
//                 // ignore: use_build_context_synchronously
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MyCart(),
//                   settings: RouteSettings(arguments: cart),
//                 ),
//               );
//             },
//             child: SizedBox(
//               width: 30,
//               height: 30,
//               child: SvgPicture.asset("assets/svg/cart 02.svg"),
//             ),
//           )
//         ],
//       ),
//       centerTitle: false,
//       elevation: 2,
//     );
//   }

//   Widget buildBody() {
//     return SafeArea(
//       child: SingleChildScrollView(
//         child: filtterItems.isEmpty
//             ? Center(
//                 child: Image.asset(
//                   "assets/nofound.jpg",
//                   fit: BoxFit.cover,
//                 ),
//               )
//             : Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: AllProduct(products: filtterItems)),
//       ),
//     );
//   }

//   Widget buildSearchTextField() {
//     return TextFormField(
//       autofocus: true,
//       controller: searchController,
//       onChanged: (value) {
//         filtterData();
//       },
//       decoration: InputDecoration(
//         hintText: "Search anything you like",
//         hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
//         prefixIcon: Icon(Icons.search, color: Colors.grey),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(color: Colors.grey),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(color: Colors.blue, width: 2.0),
//         ),
//         contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/listproduct.dart';
import '../models/resource/product_sliver.dart';
import 'allproduct.dart';
import 'chartsrceen.dart';

class Searchsrceen extends StatefulWidget {
  const Searchsrceen({super.key});

  @override
  State<Searchsrceen> createState() => _SearchsrceenState();
}

class _SearchsrceenState extends State<Searchsrceen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filtterItems = [];
  bool isSearchClick = false;

  List<Map<String, dynamic>> cart = [];

  @override
  void initState() {
    super.initState();
    filtterItems = products.take(30).toList();
  }

  void filtterData() {
    final query = searchController.text.toLowerCase();
    final temProducts = products
        .where((item) => item['name'].toLowerCase().contains(query))
        .toList();

    setState(() {
      filtterItems = temProducts;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Text(
            "RS",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Proxima Nova'),
          ),
          SizedBox(width: 8),
          Expanded(child: buildSearchTextField()),
          SizedBox(width: 5),
          GestureDetector(
            onTap: () async {
              Cart? cart = await loadCartItems();
              Navigator.push(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(
                  builder: (context) => MyCart(),
                  settings: RouteSettings(arguments: cart),
                ),
              );
            },
            child: SizedBox(
              width: 30,
              height: 30,
              child: SvgPicture.asset("assets/svg/cart 02.svg"),
            ),
          )
        ],
      ),
      centerTitle: false,
      elevation: 2,
    );
  }

  Widget buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: filtterItems.isEmpty
            ? Center(
                child: Image.asset(
                  "assets/nofound.jpg",
                  fit: BoxFit.cover,
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: AllProduct(products: filtterItems),
              ),
      ),
    );
  }

  Widget buildSearchTextField() {
    return TextFormField(
      autofocus: true,
      controller: searchController,
      onChanged: (value) {
        filtterData();
      },
      decoration: InputDecoration(
        hintText: "Search anything you like",
        hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
        prefixIcon: Icon(Icons.search, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
    );
  }

  Future<Cart?> loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart2');
    if (cartData != null) {
      return Cart.fromJson(jsonDecode(cartData));
    }
    return null;
  }
}
