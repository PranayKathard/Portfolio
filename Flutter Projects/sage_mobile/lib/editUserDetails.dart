import 'package:flutter/material.dart';
import 'package:sage_mobile/services/application_service.dart';
import 'package:sage_mobile/style/fryo_icons.dart';

class editUser extends StatefulWidget {
  @override
  _editUserState createState() => _editUserState();
}

class _editUserState extends State<editUser> {
  String email = '';
  String password = '';

  GlobalKey<FormState> _key = new GlobalKey();
  GlobalKey<FormState> _key2 = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit User'),
        backgroundColor: Color(0xff99BC1C),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(18.00),
                      child: Row(
                        children: [
                          Icon(Fryo.mail, color: Colors.black),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              'Email: ' + ApplicationService.user.email,
                              style:
                                  TextStyle(fontSize: 22, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Icon(Icons.remove_red_eye),
                        title: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'password',
                          ),
                          validator: (input) {
                            if (input!.isEmpty) {
                              return 'password is empty';
                            } else if (input !=
                                ApplicationService.user.password) {
                              return 'password incorrect';
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Icon(Icons.alternate_email),
                        title: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'new email',
                          ),
                          validator: (input) {
                            if (input!.isEmpty) {
                              return 'email is empty';
                            } else if ((input.contains('@')) == false) {
                              return 'invalid email';
                            }
                          },
                          onSaved: (input) => this.email = input!,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RaisedButton(
                        child: Text(
                          'Change email',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Color(0xff003D59),
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            _key.currentState!.save();
                            ApplicationService.updateUserEmail(this.email);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Email Updated!'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: _key2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(28.00),
                      child: Row(
                        children: [
                          Icon(Fryo.key, color: Colors.black),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              'Password',
                              style:
                                  TextStyle(fontSize: 22, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Icon(Icons.remove_red_eye),
                        title: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'current password',
                          ),
                          validator: (input) {
                            if (input!.isEmpty) {
                              return 'Password is empty';
                            } else if (input.length < 6) {
                              return 'Password must have 6 characters';
                            } else if (input !=
                                ApplicationService.user.password) {
                              return 'Password incorrect!';
                            }
                          },
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
                            labelText: 'new password',
                          ),
                          validator: (input) {
                            if (input!.isEmpty) {
                              return 'Password is empty';
                            } else if (input.length < 6) {
                              return 'Password must have 6 characters';
                            } else if (input ==
                                ApplicationService.user.password) {
                              return 'Password cannot match your previous one';
                            } else {
                              this.password = input;
                            }
                          },
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
                            labelText: 'confirm new password',
                          ),
                          validator: (input) {
                            if (input!.isEmpty) {
                              return 'Password is empty';
                            } else if (input.length < 6) {
                              return 'Password must have 6 characters';
                            } else if (input ==
                                ApplicationService.user.password) {
                              return 'Password cannot match your previous one';
                            } else if (input != this.password) {
                              return 'Password does not match';
                            }
                          },
                          onSaved: (input) => this.password = input!,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RaisedButton(
                        child: Text(
                          'Change password',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Color(0xff003D59),
                        onPressed: () {
                          if (_key2.currentState!.validate()) {
                            _key2.currentState!.save();
                            ApplicationService.updateUserPassword(
                                this.password);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Password Updated!'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
