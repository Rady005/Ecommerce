import 'package:flutter/material.dart';

import '../routes/routes.dart'; // Import your routes file

class Myorder extends StatefulWidget {
  const Myorder({super.key});

  @override
  State<Myorder> createState() => _MyorderState();
}

class _MyorderState extends State<Myorder> {
  Future<bool> _onWillPop() async {
    //Navigator.pushNamedAndRemoveUntil(context, Routes.mains, (route) => false);
    Navigator.popUntil(context, (route) => route.settings.name == Routes.mains);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Order"),
        ),
        body: Center(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return buildSampleorder();
            },
          ),
        ),
      ),
    );
  }

  Widget buildSampleorder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text("#00000058"),
              Spacer(),
              Text("\$ 8.00"),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Text("11:06 AM, 01 Jan 2025"),
              Spacer(),
              Text("Process"),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Image.asset("assets/nofound.jpg", width: 30, height: 30),
            ],
          ),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';

// import '../routes/routes.dart'; // Import your routes file

// class Myorder extends StatefulWidget {
//   const Myorder({super.key});

//   @override
//   State<Myorder> createState() => _MyorderState();
// }

// class _MyorderState extends State<Myorder> {
//   List<Map<String, dynamic>> orders = [];

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final arguments =
//         ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
//     if (arguments != null) {
//       setState(() {
//         orders.add(arguments);
//       });
//     }
//   }

//   Future<bool> _onWillPop() async {
//     Navigator.pushNamedAndRemoveUntil(context, Routes.mains, (route) => false);
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("My Order"),
//         ),
//         body: Center(
//           child: ListView.builder(
//             itemCount: orders.length,
//             itemBuilder: (BuildContext context, int index) {
//               final order = orders[index];
//               return buildOrderItem(order);
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildOrderItem(Map<String, dynamic> order) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SizedBox(
//         height: 95,
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Text("#${order['id']}"),
//                 Spacer(),
//                 Text("\$ ${order['price']}"),
//               ],
//             ),
//             Row(
//               children: [
//                 Text(order['datetime']),
//                 Spacer(),
//                 Text(order['status']),
//               ],
//             ),
//             Row(
//               children: [
//                 Image.network(order['image'], width: 30, height: 30),
//               ],
//             ),
//             const Divider(),
//           ],
//         ),
//       ),
//     );
//   }
// }
