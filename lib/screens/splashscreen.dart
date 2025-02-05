
import 'package:flutter/material.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenGameState createState() => SplashScreenGameState();
}

class SplashScreenGameState extends State<SplashScreen> {
  late FlameSplashController controller;

  @override
  void initState() {
    super.initState();
    controller = FlameSplashController(
      fadeInDuration: Duration(milliseconds: 200),
      fadeOutDuration: Duration(milliseconds: 250),
      waitDuration: Duration(seconds: 1),
      autoStart: true,
    );
  }

  @override
  void dispose() {
    controller.dispose(); // dispose it when necessary
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlameSplashScreen(
        // showBefore: (BuildContext context) {
        //   return Center(
        //     child: Image.asset('assets/iconapp.jpg'), // Replace with your logo asset
        //   );
        // },
        // showAfter: (BuildContext context) {
        //   return Center(
        //     child: Text("After the logo"),
        //   );
        // },
        theme: FlameSplashTheme.white,
        onFinish: (context) => navigateToNextScreen(),
        controller: controller,
      ),
    );
  }
}