import 'package:flutter/material.dart';

class Orderwidget {
  Orderwidget._();
  Widget buildEmptycontainer() {
    return Container(
      height: 1,
      color: Colors.white,
    );
  }

  Widget buildStauts(String process) {
    return Text(
      process,
      style: TextStyle(color: Colors.yellow, fontSize: 18),
    );
  }

  Widget buildwaitingstatus(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        decoration:
            BoxDecoration(shape: BoxShape.rectangle, color: Colors.black),
        child: Center(
          child: Text(
            "We had received your order,our customize service will\n contact you soon.Thnaks for shopping with us.",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
