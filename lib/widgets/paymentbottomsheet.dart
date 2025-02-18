import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class Paymentbottomsheet {
  Paymentbottomsheet._();
  static Future show(
    BuildContext context,
  ) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: PaymentBottomSheet(),
        );
      },
    );
  }
}

class PaymentBottomSheet extends StatefulWidget {
  const PaymentBottomSheet({super.key});

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Column(children: [
            Bounceable(
              onTap: () {
                Navigator.pop(context, "Cash on Delivery");
              },
              child: buildPayment("assets/cash 1@2x.png", "Cash on Delivery",
                  "Cash on Delivery"),
            ),
            SizedBox(
              height: 10,
            ),
            Bounceable(
              onTap: () {
                Navigator.pop(context, "Credit/Debit card");
              },
              child: buildPayment("assets/debit/cash 1@2x.png",
                  "Credit/Debit Card", "VISA,Mastercard,UnionPay"),
            ),
          ]),
        ),
      ],
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
