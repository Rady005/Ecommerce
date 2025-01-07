import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: [
          buildPayment(
              "assets/cash 1@2x.png", "Cash on Delivery", "Cash on Delivery"),
          SizedBox(
            height: 15,
          ),
          buildPayment("assets/debit/cash 1@2x.png", "Credit/Debit Card",
              "VISA,Mastercard,UnionPay"),
        ]),
      ),
    );
  }

  Widget buildPayment(String imgloc, String method, String details) {
    return SizedBox(
      height: 80,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(),
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(children: [
            Image.asset(imgloc, height: 60, width: 60),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    details,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
