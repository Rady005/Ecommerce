import 'package:assigmentflutterone/screens/widgets/loginwidget.dart';
import 'package:flutter/material.dart';

class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginWidget().buildBody(),
    );
  }
}