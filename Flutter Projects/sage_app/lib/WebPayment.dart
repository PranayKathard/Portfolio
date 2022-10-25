import 'package:flutter/cupertino.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:sage/src/Models/user.dart';
import 'package:sage/src/Services/application_service.dart';
import 'package:sage/src/shared/fryo_icons.dart';
import 'package:sage/webPay.dart';

import 'Dashboard.dart';
import 'package:flutter/material.dart';
import 'interface.dart';
import 'database_helper.dart';

class WebPayment extends StatefulWidget {
  @override
  _WebPaymentState createState() => _WebPaymentState();

  static void paymentSuccess(bool paid, BuildContext context) {
    if (paid == true) {
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              title: const Text('Payment Successfull!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () { Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context)
                      {
                        return Dashboard();
                      })
                  );},
                  child: const Text('OK'),
                ),
              ],
            ),
      );
      ApplicationService.clearCart();


    }
    else
    {
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              title: const Text('Payment Failed!'),
              actions: <Widget>[
                TextButton(
                  onPressed: ()  { Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context)
                      {
                        return Dashboard();
                      })
                  );},
                  child: const Text('OK'),
                ),
              ],
            ),
      );

    }

  }
}

class _WebPaymentState extends State<WebPayment> {

  DatabaseHelper helper = DatabaseHelper();
  Interface interface = Interface();
  String number = '';
  String cvv = '';
  int month=0;
  int year=0;


  GlobalKey<FormState> _key = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Payment'),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('images/sage_logo.png'),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Text(
                          ' Pay ZAR  '+Interface.cart.total.toStringAsFixed(2)
                              +'\n '+Interface.user.email,
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.credit_card),
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'CARD NUMBER',
                      ),
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'card number is empty';
                        }
                      },
                      onSaved: (input) => number = input,

                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.credit_card),
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'CARD EXPIRY MONTH',
                      ),
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'card expiry is empty';
                        }
                      },
                      onSaved: (input) => month = int.parse(input),

                    ),
                  ),
                ),
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                    leading: Icon(Icons.credit_card),
                    title: TextFormField(
                    decoration: InputDecoration(
                    labelText: 'CARD EXPIRY YEAR',
                    ),
                    validator: (input) {
                    if (input.isEmpty) {
                    return 'card expiry is empty';
                    }
                    },
                    onSaved: (input) => year= int.parse(input),

                    ),
                    ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Icon(Icons.credit_card),
                        title: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'CVV',
                          ),
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'CVV is empty';
                            }
                          },
                          onSaved: (input) =>
                           cvv = input,

                        ),
                      ),
                    ),


                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: RaisedButton(
                      child: Text(
                        'PAY ZAR '+ Interface.cart.total.toStringAsFixed(2),
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Color(0xff003D59),
                      disabledColor:Color(0xff003D59) ,
                      onPressed: (){ if (_key.currentState.validate()) {
                              _key.currentState.save();
                              PaymentCard card = PaymentCard(number: number, cvc:cvv, expiryMonth: month, expiryYear: year);
                              if (card.isValid()){
                      WebPay.makeWebPayment(Interface.cart.total, card, context);}
                      }
                      }

                    ),





                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(18.00),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/paystackBadge.png'),

                    ],
                  ),
                ),

              ],

            ),
          ),
        ),
      ),
    );
  }

}
