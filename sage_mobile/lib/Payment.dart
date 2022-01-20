import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:sage_mobile/Dashboard.dart';
import 'package:sage_mobile/services/application_service.dart';
import 'package:sage_mobile/services/service.dart';

class Payment {
  static const String pubKey =
      "pk_test_53195fd18ab91e4f429ba978935ddf5f1b63bcfc";

  BuildContext context;
  int price = 0;
  String email = '';
  PaystackPlugin paystack = PaystackPlugin();

  String reference = DateTime.now().toString();

  Payment({required this.context, required this.price, required this.email});

  PaymentCard getCard() {
    return PaymentCard(number: "", cvc: "", expiryMonth: 0, expiryYear: 0);
  }

  Future initialisePlugin() async {
    await paystack.initialize(publicKey: pubKey);
  }

  makePayment() async {
    initialisePlugin().then((_) async {
      Charge charge = Charge()
        ..amount = price * 100
        ..email = email
        ..reference = reference
        ..currency = 'ZAR'
        ..card = getCard();

      CheckoutResponse response = await paystack.checkout(context,
          charge: charge,
          method: CheckoutMethod.card,
          fullscreen: false,
          logo: Image.asset(
            'images/sage_logo.png',
            width: 100,
          ));

      print("Response $response");

      if (response.status == true) {
        print("Transaction successful");
        ApplicationService.clearCart();
        String header = "Purchase Received!";
        String note =
            'Thank you for you purchase. Your order is being processed. Should you have any questions or run into any problems, please contact us at 011 466 3361';
        Service.addNotification(ApplicationService.user.ID, header, note);
        ApplicationService.sendMangerOrderNote();
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
