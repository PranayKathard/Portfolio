import 'package:flutter/material.dart';
import 'package:sage_mobile/services/application_service.dart';
import 'package:sage_mobile/style/fryo_icons.dart';

import 'Payment.dart';

class checkout extends StatefulWidget {
  @override
  _checkoutState createState() => _checkoutState();
}

class _checkoutState extends State<checkout> {
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
                    leading: Icon(Icons.location_city),
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'City',
                      ),
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'field is empty please enter a city';
                        }
                      },
                      onSaved: (input) =>
                          ApplicationService.address += 'City: ' + input! + ';',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ListTile(
                    leading: Icon(Icons.house),
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Street Address',
                      ),
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'field is empty please enter your street address';
                        }
                      },
                      onSaved: (input) => ApplicationService.address +=
                          'Street: ' + input! + ';',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ListTile(
                    leading: Icon(Icons.library_books_rounded),
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Apt/Suite/Other',
                      ),
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'field is empty please enter an option';
                        }
                      },
                      onSaved: (input) => ApplicationService.address +=
                          'Apt/Suite/Other: ' + input! + ';',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ListTile(
                    leading: Icon(Icons.code),
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Zip Code',
                      ),
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'field is empty please enter a zip code';
                        }
                      },
                      onSaved: (input) => ApplicationService.address +=
                          'Zip Code: ' + input! + ';',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ListTile(
                    leading: Icon(Icons.map_outlined),
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Province',
                      ),
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'field is empty please enter a province';
                        }
                      },
                      onSaved: (input) => ApplicationService.address +=
                          'Province: ' + input! + ';',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: RaisedButton(
                    child: Text(
                      'Submit Delivery Address',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0xff003D59),
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        _key.currentState!.save();
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0.00),
                  child: TextButton(
                    onPressed: () {
                      confirmPaymentAndOrder();
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
    Payment(
            context: context,
            email: ApplicationService.user.email,
            price: ApplicationService.cart.total.ceil())
        .makePayment();
  }
}
