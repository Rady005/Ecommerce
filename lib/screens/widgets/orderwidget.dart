// import 'package:flutter/material.dart';
// import 'package:path/path.dart';

// import '../../models/allitemdisplay.dart';

// class OrderWidget{
//     Widget buildItemfromCart() {
//     return Expanded(
//       child: ListView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: cart.length,
//         itemBuilder: (context, index) {
//           final item = cart[index];
//           var product = item['product'] as Product;
//           var quantity = item['quantity'];
//           return Card(
//             elevation: 6,
//             child: Container(
//               color: Colors.white,
//               width: double.infinity,
//               height: 100,
//               child: Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 5),
//                     child: Image.network(
//                       "http:${product.image}",
//                       width: 70,
//                       height: 80,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           product.name,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "Price: ${product.priceSign} ${product.price}",
//                           style:
//                               TextStyle(fontSize: 14, color: Colors.grey[600]),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "Color: ${item['color']}",
//                           style:
//                               TextStyle(fontSize: 14, color: Colors.grey[600]),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Spacer(),
//                   Padding(
//                     padding: const EdgeInsets.all(8),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             item['quantity']++;
//                             calculateTotal();
//                           },
//                           child: Container(
//                             width: 25,
//                             height: 25,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.black,
//                                 width: 1,
//                               ),
//                             ),
//                             child: const Center(
//                               child: Text("+"),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           width: 25,
//                           height: 25,
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.black,
//                               width: 1,
//                             ),
//                           ),
//                           child: Center(child: Text("$quantity")),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             item['quantity']--;
//                             if (item['quantity'] == 0) {
//                               item['quantity'] = 1;
//                             }
//                             calculateTotal();
//                           },
//                           child: Container(
//                             width: 25,
//                             height: 25,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.black,
//                                 width: 1,
//                               ),
//                             ),
//                             child: const Center(
//                               child: Text("-"),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget buildEmptycontainer() {
//     return Container(
//       height: 1,
//       color: Colors.white,
//     );
//   }

//   Widget buildStauts(String process) {
//     return Text(
//       process,
//       style: TextStyle(color: Colors.yellow, fontSize: 18),
//     );
//   }

//   Widget buildwaitingstatus(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10, bottom: 10),
//       child: Container(
//         height: 60,
//         width: MediaQuery.of(context).size.width,
//         decoration:
//             BoxDecoration(shape: BoxShape.rectangle, color: Colors.black),
//         child: Center(
//           child: Text(
//             "We had received your order,our customize service will\n contact you soon.Thnaks for shopping with us.",
//             style: TextStyle(color: Colors.white, fontSize: 14),
//           ),
//         ),
//       ),
//     );
//   }
// }