//import 'dart:ffi';

import 'package:sage/src/Models/product.dart';
import 'package:sage/src/Services/application_service.dart';
import 'package:sage/src/shared/colors.dart';
import 'package:sage/src/shared/fryo_icons.dart';
import 'package:sage/src/shared/styles.dart';

import 'Dashboard.dart';
import 'package:flutter/material.dart';
import 'interface.dart';
import 'database_helper.dart';
import 'package:sage/src/Services/service.dart';

class AddProduct extends StatefulWidget {
  AddProduct({Key key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  DatabaseHelper helper = DatabaseHelper();
  Interface interface = Interface();
  Product product = Product();
  String name;
  String description;
  double price;
  String image;
  int quantity;
  double discount;

  GlobalKey<FormState> _addProdkey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add New Product'),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _addProdkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      onSaved: (input) => this.name = input,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      onSaved: (input) => this.description = input,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      onSaved: (input) => this.image = input,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      onSaved: (input) => this.price = double.parse(input),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Quantity Available',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      onSaved: (input) => this.quantity = int.parse(input),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Discount in %(make 0% if there is none)',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      onSaved: (input) => this.discount = double.parse(input),
                    ),
                  ),
                ),
                Container(
                  height: 300,
                  child: ListView(children: [
                    SizedBox(
                      height: 10,
                    ),
                    ////////////////////////////////////////////////////////////////////////
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text("CHOOSE CATEGORY:", style: quoteText),
                      ),
                    ),
                    Center(
                      child: Wrap(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, bottom: 10),
                            child: Container(
                              width: 150,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Category:'),
                                  DropdownButton(
                                    value: category,
                                    icon: const Icon(Fryo.arrow_down),
                                    iconSize: 20,
                                    elevation: 16,
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.blueGrey),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.green,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        category = newValue;
                                        setBool(category);
                                      });
                                    },
                                    items: <String>[
                                      'none',
                                      'bags',
                                      'laptops',
                                      'storage devices',
                                      'printer',
                                      'other'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    laptopSpec(),
                    bagSpec(),
                    storageSpec(),
                    printSpec(),
                    otherSpec(),
                    SizedBox(
                      height: 10,
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: RaisedButton(
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0xff003D59),
                    onPressed: addProd,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setBool(String choice) {
    laptop = false;
    bags = false;
    printer = false;
    storage = false;
    other = false;
    switch (choice) {
      case 'bags':
        bags = true;
        break;
      case 'laptops':
        laptop = true;
        break;
      case 'storage devices':
        storage = true;
        break;
      case 'printer':
        printer = true;
        break;
      case 'other':
        other = true;
        break;
      default:
    }
  }

  String screenDrop = '13"',
      processorDrop = 'i3',
      memoryDrop = '8GB',
      hddDrop = '256 SSD',
      lteDrop = 'yes',
      graphicsDrop = 'onboard',
      category = 'none',
      bagColorDrop = 'black',
      bagBrandDrop = 'targus',
      storeSizeDrop = '1TB',
      printBrandDrop = 'lexmark',
      printTypeDrop = 'black',
      otherTypeDrop = 'keyboard';
  bool laptop = false,
      bags = false,
      printer = false,
      storage = false,
      other = false;

  Widget laptopSpec() {
    return Visibility(
      visible: laptop,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0, left: 12.0),
            child: Text(
              "LAPTOP SPECS:",
              style: quoteText,
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Wrap(
              children: [
                Container(
                  width: 150,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.green)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Screen Size:'),
                      DropdownButton(
                        value: screenDrop,
                        icon: const Icon(Fryo.arrow_down),
                        iconSize: 20,
                        elevation: 16,
                        style:
                            TextStyle(fontSize: 12.0, color: Colors.blueGrey),
                        underline: Container(
                          height: 2,
                          color: Colors.green,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            screenDrop = newValue;
                          });
                        },
                        items: <String>['13"', '14"', '15"', '17"']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    width: 150,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.green)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Processor:'),
                        DropdownButton(
                          value: processorDrop,
                          icon: const Icon(Fryo.arrow_down),
                          iconSize: 20,
                          elevation: 16,
                          style:
                              TextStyle(fontSize: 12.0, color: Colors.blueGrey),
                          underline: Container(
                            height: 2,
                            color: Colors.green,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              processorDrop = newValue;
                            });
                          },
                          items: <String>['i3', 'i5', 'i7']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    width: 150,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.green)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Memory:'),
                        DropdownButton(
                          value: memoryDrop,
                          icon: const Icon(Fryo.arrow_down),
                          iconSize: 20,
                          elevation: 16,
                          style:
                              TextStyle(fontSize: 12.0, color: Colors.blueGrey),
                          underline: Container(
                            height: 2,
                            color: Colors.green,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              memoryDrop = newValue;
                            });
                          },
                          items: <String>['8GB', '16GB', '32GB']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    width: 150,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.green)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('HDD:'),
                        DropdownButton(
                          value: hddDrop,
                          icon: const Icon(Fryo.arrow_down),
                          iconSize: 20,
                          elevation: 16,
                          style:
                              TextStyle(fontSize: 12.0, color: Colors.blueGrey),
                          underline: Container(
                            height: 2,
                            color: Colors.green,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              hddDrop = newValue;
                            });
                          },
                          items: <String>['256 SSD', '512 SSD', '1TB SSD']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    width: 150,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.green)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('LTE:'),
                        DropdownButton(
                          value: lteDrop,
                          icon: const Icon(Fryo.arrow_down),
                          iconSize: 20,
                          elevation: 16,
                          style:
                              TextStyle(fontSize: 12.0, color: Colors.blueGrey),
                          underline: Container(
                            height: 2,
                            color: Colors.green,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              lteDrop = newValue;
                            });
                          },
                          items: <String>['any', 'yes', 'no']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    width: 150,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.green)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Graphics:'),
                        DropdownButton(
                          value: graphicsDrop,
                          icon: const Icon(Fryo.arrow_down),
                          iconSize: 20,
                          elevation: 16,
                          style:
                              TextStyle(fontSize: 12.0, color: Colors.blueGrey),
                          underline: Container(
                            height: 2,
                            color: Colors.green,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              graphicsDrop = newValue;
                            });
                          },
                          items: <String>['onboard', 'dedicated']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
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

  Widget bagSpec() {
    return Visibility(
      visible: bags,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0, left: 12.0),
            child: Text("BAG SPECS:", style: quoteText),
          ),
          SizedBox(
            height: 10,
          ),
          Wrap(
            children: [
              Container(
                width: 150,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.green)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Laptop Fit:'),
                    DropdownButton(
                      value: screenDrop,
                      icon: const Icon(Fryo.arrow_down),
                      iconSize: 20,
                      elevation: 16,
                      style: TextStyle(fontSize: 12.0, color: Colors.blueGrey),
                      underline: Container(
                        height: 2,
                        color: Colors.green,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          screenDrop = newValue;
                        });
                      },
                      items: <String>['13"', '14"', '15"', '17"']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Container(
                  width: 150,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.green)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Brand:'),
                      DropdownButton(
                        value: bagBrandDrop,
                        icon: const Icon(Fryo.arrow_down),
                        iconSize: 20,
                        elevation: 16,
                        style:
                            TextStyle(fontSize: 12.0, color: Colors.blueGrey),
                        underline: Container(
                          height: 2,
                          color: Colors.green,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            bagBrandDrop = newValue;
                          });
                        },
                        items: <String>['targus', 'lenovo']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Container(
                  width: 150,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.green)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Color:'),
                      DropdownButton(
                        value: bagColorDrop,
                        icon: const Icon(Fryo.arrow_down),
                        iconSize: 20,
                        elevation: 16,
                        style:
                            TextStyle(fontSize: 12.0, color: Colors.blueGrey),
                        underline: Container(
                          height: 2,
                          color: Colors.green,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            bagColorDrop = newValue;
                          });
                        },
                        items: <String>['black', 'grey']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget storageSpec() {
    return Visibility(
      visible: storage,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0, left: 12.0),
            child: Text("STORAGE DEVICE SPECS:", style: quoteText),
          ),
          SizedBox(
            height: 10,
          ),
          Wrap(
            children: [
              Container(
                width: 150,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.green)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Size:'),
                    DropdownButton(
                      value: storeSizeDrop,
                      icon: const Icon(Fryo.arrow_down),
                      iconSize: 20,
                      elevation: 16,
                      style: TextStyle(fontSize: 12.0, color: Colors.blueGrey),
                      underline: Container(
                        height: 2,
                        color: Colors.green,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          storeSizeDrop = newValue;
                        });
                      },
                      items: <String>['1TB', '2TB', '4TB', '8TB']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget printSpec() {
    return Visibility(
      visible: printer,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0, left: 12.0),
            child: Text("PRINTER DEVICE SPECS:", style: quoteText),
          ),
          SizedBox(
            height: 10,
          ),
          Wrap(
            children: [
              Container(
                width: 150,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.green)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Brand:'),
                    DropdownButton(
                      value: printBrandDrop,
                      icon: const Icon(Fryo.arrow_down),
                      iconSize: 20,
                      elevation: 16,
                      style: TextStyle(fontSize: 12.0, color: Colors.blueGrey),
                      underline: Container(
                        height: 2,
                        color: Colors.green,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          printBrandDrop = newValue;
                        });
                      },
                      items: <String>['lexmark']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Container(
                  width: 150,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.green)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Type:'),
                      DropdownButton(
                        value: printTypeDrop,
                        icon: const Icon(Fryo.arrow_down),
                        iconSize: 20,
                        elevation: 16,
                        style:
                            TextStyle(fontSize: 12.0, color: Colors.blueGrey),
                        underline: Container(
                          height: 2,
                          color: Colors.green,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            printTypeDrop = newValue;
                          });
                        },
                        items: <String>['black', 'color']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget otherSpec() {
    return Visibility(
      visible: other,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0, left: 12.0),
            child: Text("DEVICE SPECS:", style: quoteText),
          ),
          SizedBox(
            height: 10,
          ),
          Wrap(
            children: [
              Container(
                width: 150,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.green)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Type:'),
                    DropdownButton(
                      value: otherTypeDrop,
                      icon: const Icon(Fryo.arrow_down),
                      iconSize: 20,
                      elevation: 16,
                      style: TextStyle(fontSize: 12.0, color: Colors.blueGrey),
                      underline: Container(
                        height: 2,
                        color: Colors.green,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          otherTypeDrop = newValue;
                        });
                      },
                      items: <String>['keyboard', 'docking station']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  addProd() async {
    if (_addProdkey.currentState.validate()) {
      _addProdkey.currentState.save();
      if (category == 'none') {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Please choose a category for this product.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        String attributes = screenDrop +
            ',' +
            bagBrandDrop +
            ',' +
            bagColorDrop +
            ',' +
            processorDrop +
            ',' +
            memoryDrop +
            ',' +
            hddDrop +
            ',' +
            lteDrop +
            ',' +
            graphicsDrop +
            ',' +
            storeSizeDrop +
            ',' +
            printBrandDrop +
            ',' +
            printTypeDrop +
            ',' +
            otherTypeDrop;
        String s = await Service.addProduct(
            this.name,
            this.description,
            this.price,
            this.image,
            this.quantity,
            this.category,
            this.discount,
            attributes);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            return Dashboard();
          }),
        );
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Added Product'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                },
                child: const Text('Cancel'),
              ),
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
}
