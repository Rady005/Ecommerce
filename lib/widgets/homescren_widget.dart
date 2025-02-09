import 'dart:convert';

import 'package:assigmentflutterone/models/resource/product_sliver.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/listproduct.dart';
import '../models/resource/slide.dart';
import '../routes/routes.dart';
import '../screens/allproduct.dart';
import 'category.dart';

class Homescrenwidget {
  // Homescrenwidget._();

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 80, // Increase the height for better spacing
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
          Expanded(child: buildSearchContainer(context)),
          SizedBox(width: 5),
          GestureDetector(
            onTap: () async {
              Cart? cart = await loadCartItems();
              Navigator.pushNamed(
                // ignore: use_build_context_synchronously
                context,
                Routes.addtochart,
                arguments: cart,
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
      elevation: 0,
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

  Widget buildSearchContainer(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pushNamed(context, Routes.search);
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(Icons.search),
              SizedBox(width: 10),
              Text(
                "Search anything you like",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildCarouselSilder(context),
              const SizedBox(height: 5),
              const Divider(),
              const Category(),
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "  All Product",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              AllProduct(products: products),
              TextButton(onPressed: () {}, child: Text("View more")),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCarouselSilder(BuildContext context) {
    return Stack(children: [
      SizedBox(
        width: double
            .infinity, // Ensures the container takes the full width of the screen
        child: CarouselSlider.builder(
          itemCount: slidesCarousel.length,
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) =>
                  Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5), // Set border radius to 20
              child: Image.network(
                slidesCarousel[itemIndex],
                width: MediaQuery.of(context).size.width, // Match screen width
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/empty.jpg",
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
              ),
            ),
          ),
          options: CarouselOptions(
            aspectRatio: MediaQuery.of(context).size.width /
                200, // Adjust aspect ratio dynamically
            height: 200,
            viewportFraction: 1, // Ensures the slider items occupy full width
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 2),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              // setState(() {});
            },
          ),
        ),
      ),
    ]);
  }
}
