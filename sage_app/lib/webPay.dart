import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_paystack/src/api/model/transaction_api_response.dart';
import 'WebPayment.dart';
import 'interface.dart';

class WebPay {
  static const ROOT =
      "https://sagestoredatabase.000webhostapp.com/webPayment.php";
  static TransactionApiResponse transResponse;

  static void makeWebPayment(
      double amount, PaymentCard card, BuildContext context) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['email'] = Interface.user.email;
      map['amount'] = (amount * 100).toInt().toString();
      String sRef = DateTime.now().toString();
      List<String> slist = sRef.split(':');
      String reference = slist[0] +
          slist[1] +
          slist[2].substring(0, slist[2].indexOf(".")) +
          slist[2].substring(slist[2].indexOf(".") + 1);
      reference = reference.substring(0, reference.indexOf(" ")) +
          reference.substring(reference.indexOf(" ") + 1);
      print(reference);
      map['reference'] = reference;
      map['number'] = card.number;
      map['cvv'] = card.cvc;
      map['month'] = card.expiryMonth.toString();
      map['year'] = card.expiryYear.toString();
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Get Response: ${response.body}');
      Map<String, dynamic> responseBody = json.decode(response.body);
      //transResponse = TransactionApiResponse.fromMap(responseBody);
      WebPayment.paymentSuccess(responseBody['status'], context);
    } on Error catch (e) {
      print('Error: $e');
    }
  }
}
