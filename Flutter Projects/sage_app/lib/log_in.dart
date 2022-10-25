import 'package:flutter/cupertino.dart';
import 'package:sage/src/Services/application_service.dart';
import 'package:sage/src/Services/service.dart';
import 'Dashboard.dart';
import 'package:flutter/material.dart';
import 'interface.dart';
import 'database_helper.dart';
import 'src/Models/user.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Interface interface = Interface();
  DatabaseHelper helper = DatabaseHelper();
  String email = '', password = '';

  GlobalKey<FormState> _key = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login'),
        backgroundColor: Color(0xff99BC1C),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    color: Colors.white,
                    child: Image.asset('images/sage_logo.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(300.0, 8.0, 300.0, 8.0),
                  child: ListTile(
                    leading: Icon(Icons.alternate_email),
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Email is empty';
                        }
                      },
                      onSaved: (input) => this.email = input,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(300.0, 8.0, 300.0, 8.0),
                  child: ListTile(
                    leading: Icon(Icons.remove_red_eye),
                    title: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Password is empty';
                        }
                      },
                      onSaved: (input) => this.password = input,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: RaisedButton(
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0xff003D59),
                    onPressed: () {
                      ApplicationService.updateNumNote();
                      return login();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();

      int result1 = await emailValidator(this.email);
      bool blocked = false;
      if (result1 == 1) {
        List<User> blockList = await Service.getBlocked();
        for (User u in blockList) {
          if (u.email == this.email) {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text(
                    'You have been blocked for suspicions of fraud. If this was incorrect please send an email with a copy of your ID to vinayk@sagecomp.co.za.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
            blocked = true;
          }
        }
        int result2 = await passwordValidator(this.email, this.password);
        if ((result2 == 1) && (!blocked)) {
          Interface.user = await ApplicationService.getUser(this.email);
          if (await ApplicationService.getCart(Interface.user.getID) == null) {
            await Service.addCart(Interface.user.ID, 0);
            Interface.cart =
                await ApplicationService.getCart(Interface.user.ID);
          } else {
            Interface.cart =
                await ApplicationService.getCart(Interface.user.ID);
          }
          // await ApplicationService.getOrdersUser(Interface.user.ID);
          //await ApplicationService.getOrdersForManager();
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return Dashboard();
          }));
        } else if (!(result2 == 1)) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Incorrect password!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else if (!(result1 == 1) && (!blocked)) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Incorrect email!'),
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
  }

  emailValidator(String email) async {
    User u = await ApplicationService.getUser(email);
    if (!(u == null)) {
      return 1;
    } else {
      return 0;
    }
  }

  passwordValidator(String email, String password) async {
    User u = await ApplicationService.getUser(email);
    if (u.password == password) {
      return 1;
    } else {
      return 0;
    }
  }
}
