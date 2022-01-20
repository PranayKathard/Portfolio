import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sage/interface.dart';
import 'package:sage/src/Models/product.dart';
//import 'src/shared/Product.dart';
import 'Dashboard.dart';
import 'src/shared/styles.dart';
import 'src/shared/colors.dart';
import 'src/shared/partials.dart';
import 'src/shared/buttons.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'src/Services/application_service.dart';

class ProductPage extends StatefulWidget {
  final String pageTitle;
  final Product productData;

  ProductPage({Key key, this.pageTitle, this.productData}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  double _rating = 4;
  int _quantity = 1;
  Widget soldOut;
  @override
  Widget build(BuildContext context) {
    if (widget.productData.quantity == 0) {
      soldOut = Text(
        "SOLD OUT!",
        style: TextStyle(color: Colors.red, fontSize: 20),
      );
    } else {
      soldOut = Text("In Stock: " + widget.productData.quantity.toString());
    }
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bgColor,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: BackButton(
            color: darkText,
          ),
          title: Text(widget.productData.name, style: h4),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(top: 100, bottom: 100),
                        padding: EdgeInsets.only(top: 100, bottom: 50),
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            soldOut,
                            Text(
                                "R" +
                                    widget.productData.price.toStringAsFixed(2),
                                style: h3),
                            // Container(
                            //   margin: EdgeInsets.only(top: 5, bottom: 20),
                            //   child: SmoothStarRating(
                            //     allowHalfRating: false,
                            //     onRatingChanged: (v) {
                            //       setState(() {
                            //         _rating = v;
                            //       });
                            //     },
                            //     starCount: 5,
                            //     rating: _rating,
                            //     size: 27.0,
                            //     color: Colors.orange,
                            //     borderColor: Colors.orange,
                            //   ),
                            // ),
                            Container(
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(widget.productData.getDescription),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 25),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text('Quantity', style: h6),
                                    margin: EdgeInsets.only(bottom: 15),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 55,
                                        height: 55,
                                        child: OutlineButton(
                                          onPressed: () {
                                            setState(() {
                                              _quantity += 1;
                                            });
                                          },
                                          child: Icon(Icons.add),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Text(_quantity.toString(),
                                            style: h3),
                                      ),
                                      Container(
                                        width: 55,
                                        height: 55,
                                        child: OutlineButton(
                                          onPressed: () {
                                            setState(() {
                                              if (_quantity == 1) return;
                                              _quantity -= 1;
                                            });
                                          },
                                          child: Icon(Icons.remove),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 180,
                              child: froyoFlatBtn('Add to Cart', () {
                                if (widget.productData.quantity == 0) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text(
                                          "This item is unavailable, but we promise we'll restock it soon."),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  ApplicationService.addItemToCart(
                                      Interface.cart.CartID,
                                      widget.productData.getID,
                                      _quantity);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Added to Cart!'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) {
                                                  return Dashboard();
                                                },
                                              ),
                                            );
                                          },
                                          child: const Text('Go to cart'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 15,
                                  spreadRadius: 5,
                                  color: Color.fromRGBO(0, 0, 0, .05))
                            ]),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 200,
                        height: 160,
                        child: productItem2(widget.productData,
                            isProductPage: true,
                            onTapped: () {},
                            imgWidth: 250,
                            onLike: () {}),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
