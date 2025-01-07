

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import '../models/listproduct.dart';
import '../resource/product_sliver.dart';
import '../resource/slide.dart';
import '../routes/routes.dart';
import 'allproduct.dart';
import 'category.dart';
import 'detailprodcts.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _SildebarState();
}

class _SildebarState extends State<Homescreen> {
  List<Map<String, dynamic>> cart = [];
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
      toolbarHeight: 80, // Increase the height for better spacing
      title: Row(
        children: [
          Text(
            "RS",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(width: 8),
          Expanded(child: buildSearchContainer(context)),
          SizedBox(width: 5),
          GestureDetector(
            onTap: () async {
              Cart? cart = await loadCartItems();
              Navigator.pushNamed(
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

  Widget buildBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildCarouselSilder(),
              const SizedBox(height: 5),
              Container(
                height: 10,
                color: Colors.white,
              ),
              const Category(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "  All Product",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              AllProduct(products: products), // Pass the products list here
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCarouselSilder() {
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
              setState(() {});
            },
          ),
        ),
      ),
    ]);
  }
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
        padding: const EdgeInsets.only(top: 15, left: 10),
        child: Text(
          "Search anything you like",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    ),
  );
}
