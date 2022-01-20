import 'package:flutter/material.dart';
import 'IProd.dart';

class ViewProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFAAA8A8),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 15.0),
          Container(
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 50.0,
              child: GridView.count(
                crossAxisCount: 3,
                primary: false,
                crossAxisSpacing: 20,
                mainAxisSpacing: 50,
                childAspectRatio: 0.8,
                children: <Widget>[
                  _buildCard('TEST', '\R300.99', 'images/citygearCase.jpg',
                      false, false, context),
                  _buildCard('TEST2', '\R500.99', 'images/dock.jpg', true,
                      false, context),
                  _buildCard('TEST3', '\R100.99', 'images/dockingstation.jpg',
                      false, true, context),
                  _buildCard('TEST4', '\R200.99', 'images/intellectCase.jpg',
                      false, false, context)
                ],
              )),
          SizedBox(height: 15.0)
        ],
      ),
    );
  }

  Widget _buildCard(String name, String price, String imgPath, bool added,
      bool isFavorite, context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        height: 200,
        width: 200,
        child: InkWell(
          radius: 200,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    IProd(assetPath: imgPath, cp: price, cn: name)));
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.white60.withOpacity(0.2),
                      spreadRadius: 3.0,
                      blurRadius: 5.0)
                ],
                color: Colors.white),
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          isFavorite
                              ? Icon(Icons.favorite, color: Color(0xFF3CD30D))
                              : Icon(Icons.favorite_border,
                                  color: Color(0xFF3CD30D))
                        ])),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Hero(
                      tag: imgPath,
                      child: Container(
                          height: 200.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(imgPath),
                                  fit: BoxFit.contain)))),
                ),
                SizedBox(height: 7.0),
                Text(price,
                    style: TextStyle(
                        color: Color(0xFF3CD30D),
                        fontFamily: 'Varela',
                        fontSize: 20.0)),
                Text(name,
                    style: TextStyle(
                        color: Color(0xFF575E67),
                        fontFamily: 'Varela',
                        fontSize: 18.0)),
                Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Container(color: Color(0xFFEBEBEB), height: 1.0)),
                Padding(
                  padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 150),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (!added) ...[
                        Icon(Icons.shopping_basket,
                            color: Color(0xFF3CD30D), size: 12.0),
                        Text('Add to cart',
                            style: TextStyle(
                                fontFamily: 'Varela',
                                color: Color(0xFF3CD30D),
                                fontSize: 12.0))
                      ],
                      if (added) ...[
                        Icon(Icons.shopping_basket,
                            color: Color(0xFF3CD30D), size: 12.0),
                        Text('Add to cart',
                            style: TextStyle(
                                fontFamily: 'Varela',
                                color: Color(0xFF3CD30D),
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0)),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
