import 'package:flutter/material.dart';
import 'package:sage_mobile/models/product.dart';

//colors
const Color primaryColor = Color(0xff99BC1C);
const Color bgColor = Color(0xffF4F7FA);
const Color darkText = Colors.black54;
const Color highlightColor = Colors.green;

//logo styles
const logoWhiteStyle = TextStyle(
    fontFamily: 'Klobenz',
    fontSize: 26,
    letterSpacing: 2,
    color: Colors.white,
    fontWeight: FontWeight.bold);

//text styles
const categoryText = TextStyle(
    color: Color(0xff444444),
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins');

const prodNameText = TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins');

const priceText = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w800,
    fontFamily: 'Poppins');

const h3 = TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    fontFamily: 'Poppins');

const h4 = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins');

const h5 = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins');

const h6 = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins');

//product display styles
Widget productItemSale(
  Product prod, {
  required double imgWidth,
  onLike,
  onTapped,
  bool isProductPage = false,
}) {
  return Container(
    width: 150,
    height: 150,
    // color: Colors.red,
    child: Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          width: 150,
          height: 150,
          child: RaisedButton(
            color: Colors.white,
            elevation: (isProductPage) ? 20 : 12,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            onPressed: onTapped,
            child: Hero(
              transitionOnUserGestures: true,
              tag: prod.ID,
              child: Image.asset(
                "images/" + prod.image,
                width: imgWidth,
                height: 75,
              ),
            ),
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
                        width: 100,
                        child: Text(
                          prod.name,
                          style: prodNameText,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text("R" + prod.price.toStringAsFixed(2),
                          style: priceText),
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
                color: Colors.red,
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget productItemNoSale(
  Product prod, {
  required double imgWidth,
  onLike,
  onTapped,
  bool isProductPage = false,
}) {
  return Container(
    alignment: Alignment.topCenter,
    width: 150,
    height: 150,
    // color: Colors.red,
    child: Stack(
      children: <Widget>[
        Container(
          width: 150,
          height: 150,
          child: RaisedButton(
            color: Colors.white,
            elevation: (isProductPage) ? 20 : 12,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            onPressed: onTapped,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: Hero(
                transitionOnUserGestures: true,
                tag: prod.ID,
                child: Image.asset(
                  "images/" + prod.image,
                  width: imgWidth,
                  height: 75,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: (!isProductPage)
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 120,
                        child: Text(
                          prod.name,
                          style: prodNameText,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text("R" + prod.price.toStringAsFixed(2),
                          style: priceText),
                    ],
                  ),
                )
              : Text(' '),
        ),
      ],
    ),
  );
}

Widget productItemProdPage(
  Product prod, {
  required double imgWidth,
  onLike,
  onTapped,
  bool isProductPage = false,
}) {
  return Container(
    alignment: Alignment.topCenter,
    width: 150,
    height: 150,
    // color: Colors.red,
    child: Stack(
      children: <Widget>[
        Container(
          width: 150,
          height: 150,
          child: RaisedButton(
            color: Colors.white,
            elevation: (isProductPage) ? 20 : 12,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            onPressed: onTapped,
            child: Hero(
              transitionOnUserGestures: true,
              tag: prod.ID,
              child: Image.asset(
                "images/" + prod.image,
                width: imgWidth,
                height: 75,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: (!isProductPage)
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 120,
                        child: Text(
                          prod.name,
                          style: prodNameText,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text("R" + prod.price.toStringAsFixed(2),
                          style: priceText),
                    ],
                  ),
                )
              : Text(' '),
        ),
      ],
    ),
  );
}

//button styles
FlatButton froyoFlatBtn(String text, onPressed) {
  return FlatButton(
    onPressed: onPressed,
    child: Text(text),
    textColor: Colors.white,
    color: primaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  );
}

OutlineButton froyoOutlineBtn(String text, onPressed) {
  return OutlineButton(
    onPressed: onPressed,
    child: Text(text),
    textColor: primaryColor,
    highlightedBorderColor: highlightColor,
    borderSide: BorderSide(color: primaryColor),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  );
}
