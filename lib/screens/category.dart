import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/allitemdisplay.dart';
import '../resource/product_sliver.dart';
import '../resource/product_type.dart';
import '../routes/routes.dart';


class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  String selectedIndex = "blush";
  Map<String, dynamic> selectedProductType = productType[0];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Product Type",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productType.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedProductType = productType[index];
                        });
                        List<Map<String, dynamic>> fitterProduct = products
                            .where((product) =>
                                product["product_type"].toLowerCase() ==
                                selectedProductType["tag"]
                                    .replaceFirst(" ", "_")
                                    .toLowerCase())
                            .toList();
                        Navigator.pushNamed(
                          context,
                          Routes.blush,
                          arguments: fitterProduct,
                        );
                      },
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: SvgPicture.network(
                            "${productType[index]['image']}"),
                      ),
                    ),
                    Text(
                      "${productType[index]['tag']}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          height: 10,
          color: Colors.grey[200],
        )
      ],
    );
  }

  void detailBlushScreenClick(BuildContext context, Product product) async {
    Navigator.pushNamed(context, Routes.blush, arguments: product);
  }
}