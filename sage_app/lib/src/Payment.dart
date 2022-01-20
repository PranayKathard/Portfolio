import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:sage/interface.dart';
import 'Services/service.dart';
import '../Dashboard.dart';
import 'Services/application_service.dart';

class Payment {
  static const String pubKey =
      "pk_test_53195fd18ab91e4f429ba978935ddf5f1b63bcfc";

  BuildContext context;
  int price;
  String email;
  PaystackPlugin paystack = PaystackPlugin();

  String reference = DateTime.now().toString();

  Payment({this.context, this.price, this.email});

  PaymentCard getCard() {
    return PaymentCard(number: "", cvc: "", expiryMonth: 0, expiryYear: 0);
  }

  Future initialisePlugin() async {
    await paystack.initialize(publicKey: pubKey);
  }

  makePayment() async {
    initialisePlugin().then((_) async {
      Charge charge = Charge()
        ..amount = price
        ..email = email
        ..reference = reference
        ..card = getCard();

      CheckoutResponse response = await paystack.checkout(context,
          charge: charge,
          method: CheckoutMethod.card,
          fullscreen: false,
          logo: Image.asset('images/sage_logo.png'));

      print("Response $response");

      if (response.status == true) {
        print("Transaction successful");
        String header = "Purchase Received!";
        String note =
            'Thank you for you purchase. Your order is being processed. Should you have any questions or run into any problems, please contact us at 011 466 3361';
        Service.addNotification(Interface.user.ID, header, note);
        ApplicationService.sendMangerOrderNote();
        ApplicationService.clearCart();
      } else {
        print("Transaction failed");
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return Dashboard();
          },
        ),
      );
    });
  }
}
