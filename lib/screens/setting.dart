import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(),
      body: buildBody(),
    );
  }

  AppBar buildAppbar() {
    return AppBar(
      title: Text(
        'Setting',
        style: TextStyle(fontSize: 20),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 30,
            height: 30,
            child: SvgPicture.asset(
              "assets/svg/cart 02.svg",
              fit: BoxFit.cover,
            ),
          ),
        )
      ],
      elevation: 5,
    );
  }

  Widget buildBody() {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60, // Diameter of the CircleAvatar + border thickness
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue, // Border color
                      width: 2.0, // Border thickness
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 28, // Adjusted radius for the inner CircleAvatar
                    backgroundImage: AssetImage("assets/debit/rady.png"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ren Rady",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "16 January",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
