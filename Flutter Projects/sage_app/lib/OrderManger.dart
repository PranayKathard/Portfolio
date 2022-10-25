import 'package:flutter/cupertino.dart';
import 'package:sage/src/Models/order.dart';
import 'package:sage/src/Services/application_service.dart';
import 'package:sage/src/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:sage/viewOrderManager.dart';

class OrderManager extends StatefulWidget {
  final Order orderData; //change to orders
  const OrderManager({Key key, this.orderData}) : super(key: key);

  @override
  _OrderManagerState createState() => _OrderManagerState();
}

class _OrderManagerState extends State<OrderManager> {
  final replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String> items =
        ApplicationService.getOrderItems(widget.orderData).split(',');
    List<String> quantities =
        ApplicationService.getOrderItemQuantities(widget.orderData).split(',');
    List<String> prices =
        ApplicationService.getOrderItemPrices(widget.orderData).split(',');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text('Order #' + widget.orderData.orderID.toString()),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'ItemNames',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 400,
                          height: 400,
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, int index) {
                              return SizedBox(
                                height: 50,
                                child: Text(
                                  items[index],
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Quantity',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 400,
                          width: 20,
                          child: ListView.builder(
                            itemCount: quantities.length,
                            itemBuilder: (BuildContext context, int index) {
                              return SizedBox(
                                height: 50,
                                child: Text(
                                  quantities[index],
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 25),
                      child: Column(
                        children: [
                          Text(
                            'Price',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 400,
                            width: 200,
                            child: ListView.builder(
                              itemCount: prices.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: 50,
                                  child: Text(
                                    prices[index],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'Total : ' + widget.orderData.totalPrice.toStringAsFixed(2),
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Address:',
                          style: TextStyle(color: Colors.orange, fontSize: 25),
                        ),
                        Text(
                          widget.orderData.address.split(';')[0],
                          style: TextStyle(fontSize: 20),
                        ), //city
                        Text(widget.orderData.address.split(';')[1],
                            style: TextStyle(fontSize: 20)), //street
                        Text(widget.orderData.address.split(';')[2],
                            style: TextStyle(fontSize: 20)), //apt
                        Text(widget.orderData.address.split(';')[3],
                            style: TextStyle(fontSize: 20)), //zip
                        Text(widget.orderData.address.split(';')[4],
                            style: TextStyle(fontSize: 20)), //province
                      ],
                    ),
                    RaisedButton(
                      child: Text(
                        'Complete Order',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Color(0xff003D59),
                      onPressed: () {
                        ApplicationService.completeOrder(widget.orderData);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return viewOrdersManager();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
