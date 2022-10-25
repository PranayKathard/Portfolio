import 'package:flutter/material.dart';
import 'package:sage/ReportsPage.dart';
import 'package:sage/ViewQuote.dart';
import 'package:sage/createSpecial.dart';
import 'package:sage/delete_product.dart';
import 'package:sage/userManagement.dart';
import 'package:sage/viewOrderManager.dart';
import 'ProdCategory.dart';
import 'add_product.dart';
import 'homepage.dart';
import 'Dashboard.dart';
import 'ProductPage.dart';
import 'notifications.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sage Computer Technologies',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/dashboard': (BuildContext context) => Dashboard(),
        '/productPage': (BuildContext context) => ProductPage(),
        '/viewProdPage': (BuildContext context) => ProdCategory(
              category: 0,
            ),
        '/addProduct': (BuildContext context) => AddProduct(),
        '/deleteProduct': (BuildContext context) => DeleteProduct(),
        '/viewQuotes': (BuildContext context) => ViewQuote(),
        '/reportsPage': (BuildContext context) => ReportPage(),
        '/notifications': (BuildContext context) => notifications(),
        '/userManagement': (BuildContext context) => userManagement(),
        '/OrderManagement': (BuildContext context) => viewOrdersManager(),
        '/CreateSpecial': (BuildContext context) => createSpecial(),
      },
    );
  }
}
