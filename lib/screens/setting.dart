import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/db/dbloginmodel.dart';
import '../routes/routes.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String fullname = "";
  String username = "";
  int user_id = 0;

  @override
  void initState() {
    super.initState();
    getFullName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Setting',
        style: TextStyle(fontSize: 20),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.addtochart);
            },
            child: SizedBox(
              width: 30,
              height: 30,
              child: SvgPicture.asset(
                "assets/svg/cart 02.svg",
                fit: BoxFit.cover,
              ),
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
          // Profile Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Circle with initials
                CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Center(
                        child: Image.asset(
                            fit: BoxFit.contain,
                            width: 56,
                            height: 56,
                            "assets/profile.jpg"))),
                const SizedBox(width: 15),
                // Name and Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello $username",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "21 October",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          Container(
            color: Colors.white,
            height: 20,
          ),

          // Settings Options
          Expanded(
            child: ListView(
              children: [
                buildMenuItem(
                  icon: Icons.shopping_bag_outlined,
                  title: "My Orders",
                  onTap: () {
                    Navigator.pushNamed(context, Routes.myorder);
                  },
                ),
                const Divider(color: Colors.white),
                buildMenuItem(
                  icon: Icons.language,
                  title: "Change Language",
                  onTap: () {},
                ),
                Container(
                  color: Colors.white,
                  height: 20,
                ),
                buildMenuItem(
                  icon: Icons.info_outline,
                  title: "About",
                  onTap: () {},
                ),
                const Divider(color: Colors.white),
                buildMenuItem(
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                  onTap: () {},
                ),
                Container(
                  color: Colors.white,
                  height: 20,
                ),
                buildMenuItem(
                  icon: Icons.logout,
                  title: "Log out",
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove("isRegistered");

                    await prefs.remove("isLoggedIn");
                    await prefs.remove("user");

                    QuickAlert.show(
                      // ignore: use_build_context_synchronously
                      context: context,
                      backgroundColor: Colors.white,
                      headerBackgroundColor: Colors.yellow,
                      type: QuickAlertType.warning,
                      text: 'Are you sure you want to logout ?',
                      borderRadius: 20,
                      onConfirmBtnTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                          // ignore: use_build_context_synchronously
                          context,
                          Routes.login,
                          (route) => false,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 50,
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.black,
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        onTap: onTap,
      ),
    );
  }

  void getFullName() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var storeUsername = prefs.getString("user") ?? "users";
      var data = await LoginHelper.getUserDetails(storeUsername);
      if (data != null) {
        setState(() {
          fullname = "${data["first_name"]} ${data['last_name']}";
          username = data["username"];
          user_id = data["user_id"];
          print(fullname);
        });
      } else {
        print("User not found");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
