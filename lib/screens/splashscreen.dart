
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../routes/routes.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   SplashScreenGameState createState() => SplashScreenGameState();
// }

// class SplashScreenGameState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   Future<void> navigateToNextScreen() async {
//     final prefs = await SharedPreferences.getInstance();
//     final bool isRegistered = prefs.getBool('isRegistered') ?? false;
//     final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

//     if (isRegistered || isLoggedIn) {
//       Navigator.pushReplacementNamed(context, Routes.mains);
//     } else {
//       Navigator.pushReplacementNamed(context, Routes.login);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

//     // Navigate to the next screen after a delay
//     Future.delayed(Duration(seconds: 2), () {
//       navigateToNextScreen();
//     });
//   }

//   @override
//   void dispose() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: SystemUiOverlay.values);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blue, Colors.purple],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 200,
//               height: 200,
              
//               child: Image.asset('assets/logoApp .png')),
//             SizedBox(height: 10),
//             Text(
//               'Welcome to Beauty App',
//               style: TextStyle(
//                 fontSize: 28,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenGameState createState() => SplashScreenGameState();
}

class SplashScreenGameState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Future<void> navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isRegistered = prefs.getBool('isRegistered') ?? false;
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isRegistered || isLoggedIn) {
      Navigator.pushReplacementNamed(context, Routes.mains);
    } else {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Navigate to the next screen after a delay
    Future.delayed(Duration(milliseconds: 3000), () {
      navigateToNextScreen();
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(child: Image.asset('assets/logoApp .png')),
            SizedBox(height: 20),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Welcome to Beauty',
                  textStyle: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                  ),
                  speed: Duration(milliseconds: 135),
                ),
              ],
              totalRepeatCount: 1,
            ),
          ],
        ),
      ),
    );
  }
}