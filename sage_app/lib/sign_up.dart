import 'package:sage/log_in.dart';
import 'package:sage/src/Models/user.dart';

import 'Dashboard.dart';
import 'package:flutter/material.dart';
import 'interface.dart';
import 'database_helper.dart';
import 'src/Services/service.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  Interface interface = Interface();
  String email = '', name = '', password = '', userType = '';

  GlobalKey<FormState> _key = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Signup'),
        backgroundColor: Color(0xff99BC1C),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  padding: const EdgeInsets.all(8.0),
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
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Username is empty';
                        }
                      },
                      onSaved: (input) => this.name = input,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                        } else if (input.length < 6) {
                          return 'Password must have 6 characters';
                        } else {
                          this.password = input;
                        }
                      },
                      onSaved: (input) => this.password = input,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.remove_red_eye),
                    title: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                      ),
                      validator: (input) {
                        if (this.password != input) {
                          return 'Password doesnt Match';
                        } else if (input.length < 6) {
                          return 'Password must have 6 characters';
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: RaisedButton(
                    child: Text(
                      'Signup',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0xff003D59),
                    onPressed: signup,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  signup() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();

      int result = await interface
          .emailValidator(this.email); //#########################//
      if (result != 1) {
        await Service.addUser(this.email, this.name, this.password, "user");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Login();
            },
          ),
        );
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Center(child: const Text('Welcome!\n Please sign in.')),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
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
            title: Text("An account using this email already exists!"),
          ),
        );
      }
    }
  }
}
