import 'package:flutter/material.dart';
import 'package:sage_mobile/FullCatalogue.dart';
import 'package:sage_mobile/burgerMenuOptions/cartPage.dart';
import 'package:sage_mobile/burgerMenuOptions/notifications.dart';
import 'package:sage_mobile/burgerMenuOptions/profile.dart';
import 'package:sage_mobile/burgerMenuOptions/settings.dart';
import 'Dashboard.dart';
import 'HomePage.dart';

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
        '/catalogue': (BuildContext context) => Catalogue(),
        '/profile': (BuildContext context) => Profile(),
        '/settings': (BuildContext context) => Settings(),
        '/cart': (BuildContext context) => CartTab(),
        '/notifications': (BuildContext context) => notifications(),
      },
    );
  }
}
