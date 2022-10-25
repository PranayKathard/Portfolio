import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sage_mobile/services/application_service.dart';

import 'models/order.dart';

class myOrders extends StatefulWidget {
  @override
  _myOrdersState createState() => _myOrdersState();
}

class _myOrdersState extends State<myOrders> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          centerTitle: true,
          title: Text('My Orders'),
          backgroundColor: Color(0xff99BC1C)),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: ApplicationService.getOrdersUser(
                  ApplicationService.user.getID),
              builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                print(snapshot.hasData);
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('none');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Text('Loading...');
                  case ConnectionState.done:
                    if (!snapshot.hasData) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 70.0,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.search,
                                size: 60.0,
                                color: Colors.blueGrey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Currently there are no orders...',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                    fontSize: 18.0),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          List<String> prods = ApplicationService.getOrderItems(
                                  snapshot.data![index])
                              .split(',');
                          List<String> prices =
                              ApplicationService.getOrderItemPrices(
                                      snapshot.data![index])
                                  .split(',');
                          List<String> quantities =
                              ApplicationService.getOrderItemQuantities(
                                      snapshot.data![index])
                                  .split(',');
                          Widget processing = Text('');
                          if (snapshot.data![index].completed == 1) {
                            processing = Text(
                              'COMPLETE',
                              style: TextStyle(
                                  color: Colors.lightGreen, fontSize: 20),
                            );
                          } else {
                            processing = Text(
                              'PROCESSING...',
                              style:
                                  TextStyle(color: Colors.orange, fontSize: 20),
                            );
                          }
                          return Card(
                            child: Container(
                                height: 500.00,
                                child: SingleChildScrollView(
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          'Order #' +
                                              snapshot.data![index].orderID
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Item',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    height: 300,
                                                    child: ListView.builder(
                                                        itemCount: prods.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index2) {
                                                          return SizedBox(
                                                            height: 50,
                                                            child: Text(
                                                              prods[index2],
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Quantity',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    width: 50,
                                                    height: 300,
                                                    child: ListView.builder(
                                                        itemCount:
                                                            quantities.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index4) {
                                                          return SizedBox(
                                                            height: 50,
                                                            child: Text(
                                                              quantities[
                                                                  index4],
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Price',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    width: 80,
                                                    height: 300,
                                                    child: ListView.builder(
                                                        itemCount:
                                                            prices.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index3) {
                                                          return SizedBox(
                                                            height: 50,
                                                            child: Text(
                                                              prices[index3],
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(right: 0),
                                            child: processing),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 0),
                                          child: Text(
                                            'Total : ' +
                                                snapshot.data![index].totalPrice
                                                    .toStringAsFixed(2),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          );
                        },
                      );
                    }
                    break;
                  default:
                    return Text('default');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
