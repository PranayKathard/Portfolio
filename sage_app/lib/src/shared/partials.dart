import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sage/src/Models/product.dart';
import 'package:sage/src/shared/fryo_icons.dart';
import '../shared/colors.dart';
import '../shared/styles.dart';

Widget productItem(
  Product prod, {
  double imgWidth,
  onLike,
  onTapped,
  bool isProductPage = false,
}) {
  return Container(
    width: 280,
    height: 280,
    margin: EdgeInsets.only(left: 20),
    child: Stack(
      children: <Widget>[
        Container(
            width: 280,
            height: 280,
            child: RaisedButton(
                color: white,
                elevation: (isProductPage) ? 20 : 12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: onTapped,
                child: Hero(
                    transitionOnUserGestures: true,
                    tag: prod.ID,
                    child: Image.asset(
                      "images/" + prod.image,
                      width: (imgWidth != null) ? imgWidth : 130,
                      height: 130,
                    )))),
        Positioned(
          bottom: (isProductPage) ? 10 : 70,
          right: 0,
          child: FlatButton(
            padding: EdgeInsets.all(20),
            shape: CircleBorder(),
            onPressed: onLike,
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: (!isProductPage)
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 200,
                        child: Text(
                          prod.name,
                          style: foodNameText,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text("R" + prod.price.toStringAsFixed(2), style: priceText),
                    ],
                  ),
                )
              : Text(' '),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: (prod.discount != null)
              ? Container(
                  padding:
                      EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
                  decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(50)),
                  child: Text('-' + prod.discount.toString() + '%',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                )
              : SizedBox(width: 0),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Stack(
            children: [
              Text(
                "SALE",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
              ),
              Icon(
                Icons.star,
                size: 50,
                color: Colors.greenAccent,
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget productItem2(
  Product prod, {
  double imgWidth,
  onLike,
  onTapped,
  bool isProductPage = false,
}) {
  return Container(
    width: 280,
    height: 280,
    margin: EdgeInsets.only(left: 20),
    child: Stack(
      children: <Widget>[
        Container(
            width: 280,
            height: 280,
            child: RaisedButton(
                color: white,
                elevation: (isProductPage) ? 20 : 12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: onTapped,
                child: Hero(
                    transitionOnUserGestures: true,
                    tag: prod.ID,
                    child: Image.asset(
                      "images/" + prod.image,
                      width: (imgWidth != null) ? imgWidth : 130,
                      height: 130,
                    )))),
        Positioned(
          bottom: (isProductPage) ? 10 : 70,
          right: 0,
          child: FlatButton(
            padding: EdgeInsets.all(20),
            shape: CircleBorder(),
            onPressed: onLike,
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: (!isProductPage)
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 200,
                        child: Text(
                          prod.name,
                          style: foodNameText,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text("R" + prod.price.toStringAsFixed(2), style: priceText),
                    ],
                  ),
                )
              : Text(' '),
        ),
      ],
    ),
  );
}
