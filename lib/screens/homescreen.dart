import 'package:flutter/material.dart';

import '../../widgets/homescren_widget.dart';

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
      appBar: Homescrenwidget().buildAppBar(context),
      body: Homescrenwidget().buildBody(context),
    );
  }
}
