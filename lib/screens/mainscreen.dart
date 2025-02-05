
import 'package:assigmentflutterone/screens/myorder.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
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
  int _selectedIndex = 0;

  final List<Widget> _children = [
    const Homescreen(),
    const Myorder(),
    const Wishlistscreen(),
    const SettingScreen()
  ];
  @override
  void initState() {
    super.initState();
   
    // Perform any additional setup tasks here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _children,
      ),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 0
                  ? "assets/svg/home_solid.svg"
                  : "assets/svg/home 03.svg",
              width: 30,
              height: 30,
            ),
            title: Text('Home'),
          ),
          FlashyTabBarItem(
            icon: Icon(
              _selectedIndex == 1
                  ? Icons.shopping_cart
                  : Icons.shopping_cart_outlined,
              size: 30,
              color: Colors.black,
              weight: 3,
            ),
            title: Text('Orders'),
          ),
          FlashyTabBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 2
                  ? "assets/svg/love_solid.svg"
                  : "assets/svg/love.svg",
              width: 30,
              height: 30,
            ),
            title: Text('Wishlist'),
          ),
          FlashyTabBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 3
                  ? "assets/svg/setting_solid.svg"
                  : "assets/svg/setting.svg",
              width: 30,
              height: 30,
            ),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }
}
