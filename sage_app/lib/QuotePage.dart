import 'package:flutter/cupertino.dart';
import 'package:sage/ViewQuote.dart';
import 'package:sage/src/Models/quote.dart';
import 'package:sage/src/Services/service.dart';
import 'package:sage/src/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:sage/src/shared/fryo_icons.dart';

class QuotePage extends StatefulWidget {
  final Quote quoteData;
  const QuotePage({Key key, this.quoteData}) : super(key: key);

  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  final replyController = TextEditingController();

  String setDescriptionString(String unbroken) {
    List<String> specs = unbroken.split(';');
    switch (specs[1]) {
      case 'bags':
        return "Phone number: ${specs[0]}\n "
            "Category: ${specs[1]}\n"
            "Bag size: ${specs[2]}\n"
            "Bag brand: ${specs[3]}\n"
            "Bag color: ${specs[4]}\n"
            "Users' note: ${specs[5]}";
      case 'laptops':
        return "Phone number: ${specs[0]}\n"
            "Category: ${specs[1]}\n"
            "Processor: ${specs[2]}\n"
            "Memory: ${specs[3]}\n"
            "HDD: ${specs[4]}\n"
            "LTE: ${specs[5]}\n"
            "Graphics: ${specs[6]}\n"
            "Users' note: ${specs[7]}";
      case 'storage devices':
        return "Phone number: ${specs[0]}\n"
            "Category: ${specs[1]}\n"
            "Size: ${specs[2]}\n"
            "Users' note: ${specs[3]}";
      case 'printer':
        return "Phone number: ${specs[0]}\n"
            "Category: ${specs[1]}\n"
            "Brand: ${specs[2]}\n"
            "Color type: ${specs[3]}\n"
            "Users' note: ${specs[4]}";
      case 'other':
        return "Phone number: ${specs[0]}\n"
            "Category: ${specs[1]}\n"
            "Type: ${specs[2]}\n"
            "Users' note: ${specs[3]}";
      default:
        return 'default description';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text('Ticket ${widget.quoteData.getID}'),
        backgroundColor: primaryColor,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              "Quote",
              style: TextStyle(fontSize: 14, color: Colors.blueGrey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10,
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              height: 250,
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 12, left: 8, bottom: 8),
                    child: Row(
                      children: [
                        Text(
                          "Ticket Number:  ",
                          style: TextStyle(color: Colors.green),
                        ),
                        Text(widget.quoteData.getID.toString(),
                            style: TextStyle(fontSize: 18))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Text(
                          "User ID:  ",
                          style: TextStyle(color: Colors.green),
                        ),
                        Text(widget.quoteData.user_id.toString(),
                            style: TextStyle(fontSize: 18))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Description:  ",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      setDescriptionString(widget.quoteData.description),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              "Reply",
              style: TextStyle(fontSize: 14, color: Colors.blueGrey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10,
            ),
            child: Container(
              height: 250.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter text...', border: InputBorder.none),
                  keyboardType: TextInputType.multiline,
                  maxLines: 20,
                  controller: replyController,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Service.addNotification(widget.quoteData.user_id,
                            "Reply to Quote Request", replyController.text);
                        replyController.clear();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Reply Sent'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        "Send Reply",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Service.deleteQuote(widget.quoteData.getID);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ViewQuote();
                      }));
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Quote Deleted'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(
                      Fryo.trash,
                      color: Colors.red,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
