// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../routes/routes.dart';

// class SettingScreen extends StatefulWidget {
//   const SettingScreen({super.key});

//   @override
//   State<SettingScreen> createState() => _SettingScreenState();
// }

// class _SettingScreenState extends State<SettingScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildAppBar(context),
//       body: buildBody(),
//     );
//   }

//   AppBar buildAppBar(BuildContext context) {
//     return AppBar(
//       title: const Text(
//         'Setting',
//         style: TextStyle(fontSize: 20),
//       ),
//       actions: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.pushNamed(context, Routes.addtochart);
//             },
//             child: SizedBox(
//               width: 30,
//               height: 30,
//               child: SvgPicture.asset(
//                 "assets/svg/cart 02.svg",
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         )
//       ],
//       elevation: 5,
//     );
//   }

//   Widget buildBody() {
//     return SafeArea(
//       child: Column(
//         children: [
//           // Profile Section
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 // Circle with initials
//                 CircleAvatar(
//                   radius: 28,
//                   backgroundColor: Colors.grey.shade300,
//                   child: const Text(
//                     "SD",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 15),
//                 // Name and Date
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text(
//                       "SOK DARA",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       "21 October",
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),

//           Container(
//             color: Colors.white,
//             height: 20,
//           ),

//           // Settings Options
//           Expanded(
//             child: ListView(
//               children: [
//                 buildMenuItem(
//                   icon: Icons.shopping_bag_outlined,
//                   title: "My Orders",
//                   onTap: () {
//                     Navigator.pushNamed(context, Routes.myorder);
//                   },
//                 ),
//                 const Divider(color: Colors.white),
//                 buildMenuItem(
//                   icon: Icons.language,
//                   title: "Change Language",
//                   onTap: () {},
//                 ),
//                 Container(
//                   color: Colors.white,
//                   height: 20,
//                 ),
//                 buildMenuItem(
//                   icon: Icons.info_outline,
//                   title: "About",
//                   onTap: () {},
//                 ),
//                 const Divider(color: Colors.white),
//                 buildMenuItem(
//                   icon: Icons.privacy_tip_outlined,
//                   title: "Privacy Policy",
//                   onTap: () {},
//                 ),
//                 Container(
//                   color: Colors.white,
//                   height: 20,
//                 ),
//                 buildMenuItem(
//                   icon: Icons.logout,
//                   title: "Log out",
//                   onTap: () async {
//                     final prefers = await SharedPreferences.getInstance();
//                     await prefers.setBool("isRegistered", true);
//                     Navigator.pushNamedAndRemoveUntil(
//                       context,
//                       Routes.login,
//                       (route) => false,
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildMenuItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return SizedBox(
//       height: 50,
//       child: ListTile(
//         leading: Icon(
//           icon,
//           color: Colors.black,
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(fontSize: 16),
//         ),
//         onTap: onTap,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/routes.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
                  backgroundColor: Colors.grey.shade300,
                  child: const Text(
                    "SD",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // Name and Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "SOK DARA",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
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
                    await prefs.setBool("isLoggedIn", false);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.login,
                      (route) => false,
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
}