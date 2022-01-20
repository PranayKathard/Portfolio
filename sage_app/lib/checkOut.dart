import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:sage/src/Models/user.dart';
import 'package:sage/src/Payment.dart';
import 'package:sage/src/shared/fryo_icons.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:sage/webPay.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'Dashboard.dart';
import 'package:flutter/material.dart';
import 'WebPayment.dart';
import 'interface.dart';
import 'database_helper.dart';
import 'package:js/js.dart' as js;

class checkout extends StatefulWidget {
  @override
  _checkoutState createState() => _checkoutState();
}

class _checkoutState extends State<checkout> {
  DatabaseHelper helper = DatabaseHelper();
  Interface interface = Interface();
  String email = Interface.user.email;

  GlobalKey<FormState> _key = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CheckOut'),
        backgroundColor: Color(0xff99BC1C),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.00),
                  child: Row(
                    children: [
                      Icon(Fryo.apartment, color: Colors.black),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          'Delivery Address Details',
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ListTile(
                    leading: Icon(Icons.alternate_email),
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'City ... eg Durban',
                      ),
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'field is empty please enter a city';
                        }
                      },
                      onSaved: (input) =>
                          Interface.address += "City: " + input + ";",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ListTile(
                    leading: Icon(Icons.alternate_email),
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Street Address eg.. 12 Bedford View',
                      ),
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'field is empty please enter your street address';
                        }
                      },
                      onSaved: (input) =>
                          Interface.address += "Street: " + input + ";",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ListTile(
                    leading: Icon(Icons.alternate_email),
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Apt/Suite/Other',
                      ),
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'field is empty please enter an option';
                        }
                      },
                      onSaved: (input) => Interface.address +=
                          "Apt/Suite/Other: " + input + ";",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ListTile(
                    leading: Icon(Icons.alternate_email),
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Zip Code',
                      ),
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'field is empty please enter a zip code';
                        }
                      },
                      onSaved: (input) =>
                          Interface.address += "Zip Code: " + input + ";",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ListTile(
                    leading: Icon(Icons.alternate_email),
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Province eg.. Kwa-Zulu-Natal',
                      ),
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'field is empty please enter a province';
                        }
                      },
                      onSaved: (input) =>
                          Interface.address += "Province: " + input + ";",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_key.currentState.validate()) {
                        _key.currentState.save();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Delivery address saved!'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Submit Delivery Address',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0xff003D59),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0.00),
                  child: TextButton(
                    onPressed: () {
                      String s = DateTime.now().toString();
                      List<String> slist = s.split(':');
                      print(slist);
                      if ((defaultTargetPlatform == TargetPlatform.iOS) ||
                          (defaultTargetPlatform == TargetPlatform.android)) {
                        Payment(
                                context: context,
                                email: email,
                                price: (Interface.cart.total * 100).toInt())
                            .makePayment();
                      } else {
                        //WebPay.makeWebPayment(Interface.cart.total);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                              return WebPayment();
                            })
                        );
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                    child: Center(
                      child: Text(
                        'Make Payment',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void confirmPaymentAndOrder() {
    print(defaultTargetPlatform);
    print("this not a mobile platform");
  }

}
