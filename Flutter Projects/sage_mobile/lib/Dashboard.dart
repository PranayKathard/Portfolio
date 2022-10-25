import 'package:flutter/material.dart';
import 'package:sage_mobile/FullCatalogue.dart';
import 'package:sage_mobile/burgerMenuOptions/cartPage.dart';
import 'package:sage_mobile/services/application_service.dart';
import 'package:sage_mobile/style/fryo_icons.dart';
import 'package:sage_mobile/style/stylesheet.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  void initState() {
    super.initState();
    ApplicationService.updateNumNote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff99BC1C),
        title: new Text('sage',
            style: logoWhiteStyle, textAlign: TextAlign.center),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return CartTab();
                    },
                  ),
                );
              },
              icon: Icon(Icons.shopping_cart))
        ],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Center(
                  child: Text('sage',
                      style: logoWhiteStyle, textAlign: TextAlign.center)),
            ),
            burgerMenuListTile(context, 'View Products', '/catalogue'),
            burgerMenuListTileNote(context, 'Notifications', '/notifications'),
            burgerMenuListTile(context, 'Profile', '/profile'),
            burgerMenuListTile(context, 'Settings', '/settings'),
          ],
        ),
      ),
      body: Container(
        color: Color(0xffB9D252),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              headerCategoryItem('All', Fryo.list, onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      Catalogue.categoryDrop = 'All';
                      return Catalogue();
                    },
                  ),
                );
              }),
              SizedBox(
                height: 15,
              ),
              headerCategoryItem('Bags', Fryo.briefcase, onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      Catalogue.categoryDrop = 'Bags';
                      return Catalogue();
                    },
                  ),
                );
              }),
              SizedBox(
                height: 15,
              ),
              headerCategoryItem('Laptops', Fryo.laptop, onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      Catalogue.categoryDrop = 'Laptops';
                      return Catalogue();
                    },
                  ),
                );
              }),
              SizedBox(
                height: 15,
              ),
              headerCategoryItem('Storage Devices', Fryo.cloud, onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      Catalogue.categoryDrop = 'Storage Devices';
                      return Catalogue();
                    },
                  ),
                );
              }),
              SizedBox(
                height: 15,
              ),
              headerCategoryItem('Printer', Fryo.printer, onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      Catalogue.categoryDrop = 'Printer';
                      return Catalogue();
                    },
                  ),
                );
              }),
              SizedBox(
                height: 15,
              ),
              headerCategoryItem('Other', Fryo.keyboard, onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      Catalogue.categoryDrop = 'Other';
                      return Catalogue();
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  //for burger menu options
  ListTile burgerMenuListTile(
      BuildContext context, String heading, String pushPage) {
    return ListTile(
      title: Text(heading),
      onTap: () {
        Navigator.pushNamed(
          context,
          pushPage,
        );
      },
    );
  }

  ListTile burgerMenuListTileNote(
      BuildContext context, String heading, String pushPage) {
    if (ApplicationService.numNotifications == 0) {
      return ListTile(
        title: Text(heading),
        onTap: () {
          setState(() {
            ApplicationService.updateNumNote();
          });
          Navigator.pushNamed(
            context,
            pushPage,
          );
        },
      );
    } else {
      return ListTile(
        title: Text(heading),
        onTap: () {
          setState(() {
            ApplicationService.updateNumNote();
          });
          Navigator.pushNamed(
            context,
            pushPage,
          );
        },
        trailing: Stack(alignment: Alignment.center, children: [
          Icon(
            Icons.circle,
            color: Colors.red,
          ),
          Text(
            ApplicationService.numNotifications.toString(),
            style: TextStyle(color: Colors.white),
          )
        ]),
      );
    }
  }
}

Widget headerCategoryItem(String name, IconData icon, {onPressed}) {
  return Container(
    margin: EdgeInsets.only(left: 15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: 5),
            width: 86,
            height: 86,
            child: FloatingActionButton(
              shape: CircleBorder(),
              heroTag: name,
              onPressed: onPressed,
              backgroundColor: Colors.white,
              child: Icon(icon, size: 35, color: Colors.black87),
            )),
        Text(name + ' ›', style: categoryText)
      ],
    ),
  );
}
