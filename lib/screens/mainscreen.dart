import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import 'homescreen.dart';
import 'setting.dart';
import 'wishlistscreen.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int curentindex = 0;

  final List<Widget> _children = [
    const Homescreen(),
    const Wishlistscreen(),
    const SettingScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[curentindex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: curentindex,
        onTap: (value) {
          setState(() {
            curentindex = value;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
              icon: curentindex == 0
                  ? SvgPicture.asset(
                      "assets/svg/home_solid.svg",
                      // colorFilter:
                      //     const ColorFilter.mode(Colors.black, BlendMode.src),
                    )
                  : SvgPicture.asset(
                      "assets/svg/home 03.svg",
                      // colorFilter:
                      //     const ColorFilter.mode(Colors.black, BlendMode.src),
                    ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: curentindex == 1
                  ? SvgPicture.asset(
                      "assets/svg/love_solid.svg",
                    )
                  : SvgPicture.asset(
                      "assets/svg/love.svg",
                    ),
              label: 'Wishlist'),
          BottomNavigationBarItem(
              icon: curentindex == 2
                  ? SvgPicture.asset(
                      "assets/svg/setting_solid.svg",
                    )
                  : SvgPicture.asset(
                      "assets/svg/setting.svg",
                    ),
              label: 'Setting'),
        ],
      ),
    );
  }
}
