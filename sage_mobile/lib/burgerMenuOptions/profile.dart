import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sage_mobile/editUserDetails.dart';
import 'package:sage_mobile/myOrders.dart';
import 'package:sage_mobile/services/application_service.dart';
import 'package:sage_mobile/style/fryo_icons.dart';
import 'package:sage_mobile/style/stylesheet.dart';

import '../HomePage.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('profile', style: logoWhiteStyle, textAlign: TextAlign.center),
        backgroundColor: Color(0xff99BC1C),
        centerTitle: true,
      ),
      backgroundColor: Color(0xffB9D252),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(left: 15, top: 10),
            child: Text("MY ACCOUNT",
                style: TextStyle(fontSize: 14.0, color: Colors.blueGrey)),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return myOrders();
                          },
                        ),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                    child: Row(
                      children: [
                        Icon(Fryo.book, color: Colors.black),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Orders',
                            style:
                                TextStyle(fontSize: 12.0, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, top: 10),
            child: Text("DETAILS",
                style: TextStyle(fontSize: 14.0, color: Colors.blueGrey)),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Username: ',
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    Text(ApplicationService.user.getName,
                        style: TextStyle(fontSize: 12.0))
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Email: ',
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    Text(ApplicationService.user.email,
                        style: TextStyle(fontSize: 12.0))
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return editUser();
                        },
                      ),
                    );
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white)),
                  child: Center(
                    child: Text(
                      'Edit Details',
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return HomePage();
                        },
                      ),
                    );
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white)),
                  child: Center(
                    child: Text(
                      'Sign Out',
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
