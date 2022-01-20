import 'package:flutter/cupertino.dart';
import 'package:sage/src/Models/user.dart';
import 'package:sage/src/shared/colors.dart';
import 'package:sage/src/shared/fryo_icons.dart';
import 'package:flutter/material.dart';
import 'package:sage/src/Services/service.dart';

class userManagement extends StatefulWidget {
  @override
  _userManagementState createState() => _userManagementState();
}

class _userManagementState extends State<userManagement> {
  void getUser(String email) async {
    List<User> list = await Service.getUsers();
    for (User u in list) {
      if (u.getEmail == email) {
        this.user = u;
      }
    }
  }

  void getBlockedUser(String email) async {
    List<User> list = await Service.getBlocked();
    for (User u in list) {
      if (u.getEmail == email) {
        this.blockedUser = u;
      }
    }
  }

  void unblock() async {
    getBlockedUser(this.emailBlocked);
    await new Future.delayed(new Duration(milliseconds: 500));
    if (!(blockedUser == null)) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(
              'User located. Are you sure you would like to unblock this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'OK');
                // await Service.addUser(blockedUser.email, blockedUser.name,
                //     blockedUser.password, blockedUser.userType);
                String s = await Service.deleteBlocked(this.emailBlocked);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Cannot locate user in blocked users list'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void block() async {
    getUser(this.emailUser);
    await new Future.delayed(new Duration(milliseconds: 500));
    if (!(user == null)) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(
              'User located. Are you sure you would like to block this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'OK');
                await Service.addBlocked(
                    user.email, user.name, user.password, user.userType);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Cannot locate user in users list'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  User user;
  User blockedUser;
  String emailUser, emailBlocked;
  GlobalKey<FormState> _key = new GlobalKey();
  GlobalKey<FormState> _key2 = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('User Management'),
        backgroundColor: Color(0xff99BC1C),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 300,
              child: SingleChildScrollView(
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(28.00),
                        child: Row(
                          children: [
                            Icon(Fryo.warning, size: 80.0, color: Colors.black),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                'Block User',
                                style: TextStyle(
                                    fontSize: 22.0, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: ListTile(
                          title: TextFormField(
                            decoration: InputDecoration(
                              labelText:
                                  'enter the users email you want to block',
                            ),
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'email is empty please fill in the correct email';
                              }
                            },
                            onSaved: (input) => this.emailUser = input,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: RaisedButton(
                          child: Text(
                            'BLOCK USER',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Color(0xff003D59),
                          onPressed: () {
                            if (_key.currentState.validate()) {
                              _key.currentState.save();
                              block();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 300,
              child: SingleChildScrollView(
                child: Form(
                  key: _key2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(28.00),
                        child: Row(
                          children: [
                            Icon(Fryo.user, size: 80.0, color: Colors.black),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                'Unblock User',
                                style: TextStyle(
                                    fontSize: 22.0, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: ListTile(
                          title: TextFormField(
                            decoration: InputDecoration(
                              labelText:
                                  'enter the users email you want to unblock',
                            ),
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'email is empty please fill in the correct email';
                              }
                            },
                            onSaved: (input) => this.emailBlocked = input,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: RaisedButton(
                          child: Text(
                            'UNBLOCK USER',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Color(0xff003D59),
                          onPressed: () {
                            if (_key2.currentState.validate()) {
                              _key2.currentState.save();
                              unblock();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Container(
                    height: 250,
                    color: Colors.white,
                    width: 1800,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "USER LIST",
                          style: TextStyle(fontSize: 18),
                        ),
                        FutureBuilder(
                          future: Service.getUsers(),
                          builder:
                              (context, AsyncSnapshot<List<User>> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return Text('none');
                              case ConnectionState.active:
                              case ConnectionState.waiting:
                                return Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text('Loading...'),
                                ));
                              case ConnectionState.done:
                                return Flexible(
                                  fit: FlexFit.loose,
                                  child: ListView.builder(
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                  text:
                                                      'ID: ${snapshot.data[index].ID}     USER NAME: ${snapshot.data[index].name}     EMAIL: ${snapshot.data[index].email}'),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            )
                                          ],
                                        );
                                      }),
                                );
                              default:
                                return Text('default');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                color: Colors.redAccent,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Container(
                    height: 250,
                    color: Colors.redAccent,
                    width: 1800,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "BLOCKED USER LIST",
                          style: TextStyle(fontSize: 18, color: white),
                        ),
                        FutureBuilder(
                          future: Service.getBlocked(),
                          builder:
                              (context, AsyncSnapshot<List<User>> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return Text('none');
                              case ConnectionState.active:
                              case ConnectionState.waiting:
                                return Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text('Loading...'),
                                ));
                              case ConnectionState.done:
                                return Flexible(
                                  fit: FlexFit.loose,
                                  child: ListView.builder(
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text:
                                                    'ID: ${snapshot.data[index].ID}     USER NAME: ${snapshot.data[index].name}     EMAIL: ${snapshot.data[index].email}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            )
                                          ],
                                        );
                                      }),
                                );
                              default:
                                return Text('default');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
