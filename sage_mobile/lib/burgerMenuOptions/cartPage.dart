import 'package:flutter/material.dart';
import 'package:sage_mobile/models/cartItem.dart';
import 'package:sage_mobile/services/application_service.dart';
import 'package:sage_mobile/style/fryo_icons.dart';
import 'package:sage_mobile/style/stylesheet.dart';

import '../checkOut.dart';

class CartTab extends StatefulWidget {
  @override
  _CartTabState createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  late Future<List<CartItem>> items;
  @override
  void initState() {
    super.initState();
    items = _getItems();
  }

  Future<List<CartItem>> _getItems() async {
    await new Future.delayed(new Duration(milliseconds: 1250));
    List<CartItem> list =
        await ApplicationService.getItems(ApplicationService.cart.CartID);
    ApplicationService.calculateTotal();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
            future: items,
            builder: (context, AsyncSnapshot<List<CartItem>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('none');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Updating Cart...'),
                  ));
                case ConnectionState.done:
                  if ((snapshot.data == null) || (snapshot.data!.isEmpty)) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 250),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 70.0,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Fryo.cart,
                                size: 60.0,
                                color: Colors.blueGrey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'You have no items in your cart',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                    fontSize: 18.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Container(
                          height: 623,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(minHeight: 100),
                                  child: ListTile(
                                    trailing: Container(
                                      margin: EdgeInsets.all(5.0),
                                      child: Text(
                                        '\R' +
                                            snapshot.data![index].subtotal
                                                .toStringAsFixed(2),
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    leading: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage("images/" +
                                                snapshot.data![index].pImage),
                                            fit: BoxFit.fill,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                    title: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          child: Text(
                                            snapshot.data![index].pName,
                                            style: TextStyle(
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        SizedBox(
                                          width: 50,
                                          child: Container(
                                            width: 50.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              border: Border.all(
                                                width: 0.8,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      ApplicationService
                                                          .removeItemFromCart(
                                                              snapshot
                                                                  .data![index]
                                                                  .prodID,
                                                              snapshot
                                                                  .data![index]
                                                                  .cartID);
                                                      items = _getItems();
                                                    });
                                                  },
                                                  child: Text(
                                                    '-',
                                                    style: TextStyle(
                                                      color: primaryColor,
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 5.0),
                                                Text(
                                                  snapshot.data![index].quantity
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(width: 5.0),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      ApplicationService
                                                          .addItemToCart(
                                                              snapshot
                                                                  .data![index]
                                                                  .cartID,
                                                              snapshot
                                                                  .data![index]
                                                                  .prodID,
                                                              1);
                                                      items = _getItems();
                                                    });
                                                  },
                                                  child: Text(
                                                    '+',
                                                    style: TextStyle(
                                                      color: primaryColor,
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: snapshot.data!.length,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, -1),
                                blurRadius: 5.0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: SizedBox(
                                    width: 100,
                                    height: 30,
                                    child: RaisedButton(
                                      child: Center(
                                        child: Text(
                                          'checkout',
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 15,
                                            fontFamily: "Klobenz",
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        //payment gate goes here:
                                        ApplicationService.address = '';
                                        Navigator.push(context,
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return checkout();
                                        }));
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total Cost: R ' +
                                          ApplicationService.cart.total
                                              .toStringAsFixed(2),
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 18,
                                        fontFamily: "Klobenz",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }
                default:
                  return Text('default');
              }
            },
          ),
        ],
      ),
    );
  }
}
