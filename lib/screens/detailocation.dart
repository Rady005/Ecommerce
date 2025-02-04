import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/routes.dart';
import 'map_screen.dart';

class Detailocation extends StatefulWidget {
  const Detailocation({super.key});

  @override
  State<Detailocation> createState() => _DetailocationState();
}

class _DetailocationState extends State<Detailocation> {
  String location = "Select your Location";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find your Location'),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context, Routes.map);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add),
                    const Text('Add Location'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void pushMapscreen(BuildContext context) async {
    final selectedAddress = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
      ),
    );

    if (selectedAddress is String) {
      setState(() {
        location = selectedAddress;
        _savePreferences();
      });
    }
  }

  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('location', location);
    // await prefs.setString('phonenumber', phonenumber);
  }
}
