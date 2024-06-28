import 'package:flutter/material.dart';
import 'package:sage/ProdCategory.dart';
import 'package:sage/checkOut.dart';
import 'package:sage/editUserDetails.dart';
import 'package:sage/homepage.dart';
import 'package:sage/src/Services/application_service.dart';
import 'package:sage/src/myOrders.dart';
import 'src/Models/cartItem.dart';
import 'src/shared/styles.dart';
import 'src/shared/colors.dart';
import 'src/shared/fryo_icons.dart';
import 'ProductPage.dart';
import 'src/shared/partials.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'interface.dart';
import 'src/Models/product.dart';
import 'src/Services/service.dart';

class Dashboard extends StatefulWidget {
  final String pageTitle;

  Dashboard({required Key key, required this.pageTitle}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  //variables
  int _selectedIndex = 0; //for tabs
  Interface interface = Interface(); //for static user
  ApplicationService as = ApplicationService(); //database
  late Future<List<Product>> specials;

  get key => null;

  @override
  void initState() {
    super.initState();
    ApplicationService.updateNumNote();
  }

  @override
  Widget build(BuildContext context) {
    final _tabs = [
      StoreTab(key: key,),
      CartTab(key: key,),
      QuoteTab(),
      profileTab(context),
      settingsTab(context),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
            title: new Text('sage',
                style: logoWhiteStyle, textAlign: TextAlign.center),
            centerTitle: true,
            elevation: 0,
            backgroundColor: primaryColor),
        body: _tabs[_selectedIndex],
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
              burgerMenuListTile(
                  context, 'View Products', true, '/viewProdPage', true),
              burgerMenuListTileNote(
                  context, 'Notifications', true, '/notifications', true),
              burgerMenuListTile(
                  context, 'Add Product', true, '/addProduct', false),
              burgerMenuListTile(
                  context, 'Delete Product', true, '/deleteProduct', false),
              burgerMenuListTile(
                  context, 'Create Special', true, '/CreateSpecial', false),
              burgerMenuListTile(context, 'User Management System', true,
                  '/userManagement', false),
              burgerMenuListTile(
                  context, 'View Quotes', true, '/viewQuotes', false),
              burgerMenuListTile(
                  context, 'Reports', true, '/reportsPage', false),
              burgerMenuListTile(
                  context, 'Orders', true, '/OrderManagement', false),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            bottomNavBarItem(Fryo.shop, 'Store'),
            bottomNavBarItem(Fryo.cart, 'My Cart'),
            bottomNavBarItem(Fryo.question_circle, 'Quotes'),
            bottomNavBarItem(Fryo.user_1, 'Profile'),
            bottomNavBarItem(Fryo.cog_1, 'Settings'),
          ],
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.green[600],
          onTap: _onItemTapped,
        ));
  }

  BottomNavigationBarItem bottomNavBarItem(IconData i, String s) {
    return BottomNavigationBarItem(
        icon: Icon(i),
        label: s);
  }

  ListTile burgerMenuListTile(BuildContext context, String heading,
      bool enabled, String pushPage, bool userPage) {
    if ((Interface.user.getUserType == 'user') & (!userPage)) {
      heading = '';
      enabled = false;
    }
    return ListTile(
      enabled: enabled,
      title: Text(heading),
      onTap: () {
        Navigator.pushNamed(
          context,
          pushPage,
        );
      },
    );
  }

  ListTile burgerMenuListTileNote(BuildContext context, String heading,
      bool enabled, String pushPage, bool userPage) {
    if ((Interface.user.getUserType == 'user') & (!userPage)) {
      heading = '';
      enabled = false;
    }
    if (Interface.numNotifications == 0) {
      return ListTile(
        enabled: enabled,
        title: Text(heading),
        onTap: () {
          Navigator.pushNamed(
            context,
            pushPage,
          );
        },
      );
    } else {
      return ListTile(
        enabled: enabled,
        title: Text(heading),
        onTap: () {
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
            Interface.numNotifications.toString(),
            style: TextStyle(color: Colors.white),
          )
        ]),
      );
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

class StoreTab extends StatefulWidget {
  StoreTab({required Key key}) : super(key: key);
  @override
  _StoreTabState createState() => _StoreTabState();
}

class _StoreTabState extends State<StoreTab> {
  Future<List<Product>> _getSpecials() async {
    return await ApplicationService.getSpecials();
  }

  late Future<List<Product>> specials;
  @override
  void initState() {
    super.initState();
    specials = _getSpecials();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        headerTopCategories(context),
        FutureBuilder(
          future: specials,
          builder: (context, AsyncSnapshot<List<Product>> snapshot) {
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
                return Expanded(
                  child: GridView.builder(
                    itemBuilder: (context, index) {
                      return Center(
                        child: productItem(
                          snapshot.data![index],
                          onTapped: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return new ProductPage(
                                    productData: snapshot.data![index],
                                  );
                                },
                              ),
                            );
                          }, imgWidth: 0.0,
                        ),
                      );
                    },
                    itemCount: snapshot.data?.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5),
                  ),
                );
              default:
                return Text('default');
            }
          },
        ),
      ],
    );
  }
}

// wrap the horizontal listview inside a sizedBox..
Widget headerTopCategories(BuildContext context) {
  return Container(
    color: Color(0xffB9D253),
    height: 160,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
              child: SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: <Widget>[
                    headerCategoryItem('Bags', Fryo.briefcase, onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ProdCategory(
                              category: 1,
                            );
                          },
                        ),
                      );
                    }),
                    headerCategoryItem('Laptops', Fryo.laptop, onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ProdCategory(
                              category: 2,
                            );
                          },
                        ),
                      );
                    }),
                    headerCategoryItem('Storage Devices', Fryo.cloud,
                        onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ProdCategory(
                              category: 3,
                            );
                          },
                        ),
                      );
                    }),
                    headerCategoryItem('Printer', Fryo.printer, onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ProdCategory(
                              category: 4,
                            );
                          },
                        ),
                      );
                    }),
                    headerCategoryItem('Other', Fryo.keyboard, onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ProdCategory(
                              category: 5,
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget headerCategoryItem(String name, IconData icon, {onPressed}) {
  return Container(
    margin: EdgeInsets.only(left: 15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: 10),
            width: 86,
            height: 86,
            child: FloatingActionButton(
              shape: CircleBorder(),
              heroTag: name,
              onPressed: onPressed,
              backgroundColor: white,
              child: Icon(icon, size: 35, color: Colors.black87),
            )),
        Text(name + ' ›', style: categoryText)
      ],
    ),
  );
}

////////////////////////////////////////////////////////////////////////////////

Widget settingsTab(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(left: 15, top: 10),
        child: Text("NOTIFICATION SETTINGS",
            style: TextStyle(fontSize: 14.0, color: Colors.blueGrey)),
      ),
      Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Receive latest news and special offers via email?',
                        style: TextStyle(color: Colors.black)),
                    ToggleSwitch(
                      initialLabelIndex: 0,
                      minWidth: 50.0,
                      minHeight: 30.0,
                      fontSize: 10.0,
                      activeBgColor: [Colors.green],
                      activeFgColor: Colors.white,
                      labels: ['Yes', 'No'],
                      onToggle: (index) {
                        print('switched to: $index');
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // Container(
      //   margin: EdgeInsets.only(left: 15, top: 10),
      //   child: Text("PREFERENCE SETTINGS",
      //       style: TextStyle(fontSize: 14.0, color: Colors.blueGrey)),
      // ),
      // Container(
      //   margin: const EdgeInsets.all(10.0),
      //   decoration: BoxDecoration(
      //       color: Colors.white,
      //       borderRadius: BorderRadius.all(Radius.circular(10))),
      //   child: Center(
      //     child: Column(
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.all(20.0),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Text('Dark Mode', style: TextStyle(color: Colors.black)),
      //               ToggleSwitch(
      //                 initialLabelIndex: 0,
      //                 minWidth: 50.0,
      //                 minHeight: 30.0,
      //                 fontSize: 10.0,
      //                 activeBgColor: Colors.green,
      //                 activeFgColor: Colors.white,
      //                 labels: ['Yes', 'No'],
      //                 onToggle: (index) {
      //                   print('switched to: $index');
      //                 },
      //               ),
      //             ],
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    ],
  );
}

////////////////////////////////////////////////////////////////////////////////

class CartTab extends StatefulWidget {
  CartTab({required Key key}) : super(key: key);

  @override
  _CartTabState createState() => _CartTabState();
}

class _CartTabState extends State<CartTab>
    with AutomaticKeepAliveClientMixin<CartTab> {
  late Future<List<CartItem>> items;
  //double total;
  @override
  void initState() {
    super.initState();
    items = _getItems();
    //ApplicationService.initialiseCartItems();
    //ApplicationService.calculateTotal();
  }

  Future<List<CartItem>> _getItems() async {
    await new Future.delayed(new Duration(milliseconds: 1100));
    List<CartItem> list =
        await ApplicationService.getItems(Interface.cart.CartID);

    ApplicationService.calculateTotal();
    //total = Interface.cart.getTotal;
    return list;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder(
            future: items,
            builder: (context, AsyncSnapshot<List<CartItem>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('none');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Updating Cart...'),
                  ));
                case ConnectionState.done:
                  // ApplicationService.calculateTotal();
                  //total = Interface.cart.getTotal;
                  if ((!snapshot.hasData) || (snapshot.data?.length == 0)) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 200.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 70.0,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Fryo.cart,
                                size: 60.0,
                                color: Colors.blueGrey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'You have no items in your cart',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                    fontSize: 18.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Container(
                          height: 565,
                          child: ListView.builder(
                            itemExtent: 100,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(minHeight: 150),
                                  child: ListTile(
                                    trailing: Container(
                                      margin: EdgeInsets.all(10.0),
                                      child: Text(
                                        '\R' +
                                            snapshot.data![index].subtotal
                                                .toStringAsFixed(2),
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    leading: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage("images/" +
                                                snapshot.data![index].pImage),
                                            fit: BoxFit.fill,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                    title: Row(
                                      children: [
                                        Container(
                                          width: 400,
                                          child: Text(
                                            snapshot.data![index].pName,
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        SizedBox(
                                          width: 100,
                                          child: Container(
                                            width: 100.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              border: Border.all(
                                                width: 0.8,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      ApplicationService
                                                          .removeItemFromCart(
                                                              snapshot
                                                                  .data![index]
                                                                  .prodID,
                                                              snapshot
                                                                  .data![index]
                                                                  .cartID);
                                                      /*snapshot.data[index]
                                                          .quantity -= 1;*/
                                                      items = _getItems();
                                                    });
                                                  },
                                                  child: Text(
                                                    '-',
                                                    style: TextStyle(
                                                      color: primaryColor,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 20.0),
                                                Text(
                                                  snapshot.data![index].quantity
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(width: 20.0),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      ApplicationService
                                                          .addItemToCart(
                                                              snapshot
                                                                  .data![index]
                                                                  .cartID,
                                                              snapshot
                                                                  .data![index]
                                                                  .prodID,
                                                              1);
                                                      // Service.updateProduct(
                                                      //     Interface
                                                      //         .cartProducts[
                                                      //     index]);
                                                      /*snapshot.data[index]
                                                          .quantity += 1;*/
                                                      // total = Interface.cart.getTotal;
                                                      items = _getItems();
                                                    });
                                                  },
                                                  child: Text(
                                                    '+',
                                                    style: TextStyle(
                                                      color: primaryColor,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: snapshot.data!.length,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, -1),
                                blurRadius: 5.0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: FloatingActionButton(
                                    child: Text(
                                      'checkout',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 35,
                                        fontFamily: "Klobenz",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () {
                                      //payment gate goes here:
                                      Interface.address = '';
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return checkout();
                                      }));
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total Cost: R ' +
                                          Interface.cart.total
                                              .toStringAsFixed(2),
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 18,
                                        fontFamily: "Klobenz",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                default:
                  return Text('default');
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////

class QuoteTab extends StatefulWidget {
  @override
  _QuoteTabState createState() => _QuoteTabState();
}

class _QuoteTabState extends State<QuoteTab> {
  addQuote(String text, int i) async {
    await Service.addQuote(text, i);
  }

  sendNote(int user_id, String header, String note) async {
    ApplicationService.updateNumNote();
    await Service.addNotification(user_id, header, note);
  }

  Interface interface = Interface();
  final descriptionController = TextEditingController();
  final phoneController = TextEditingController();
  late List<String> specList;
  late String descriptionString;
  String screenDrop = 'any',
      processorDrop = 'any',
      memoryDrop = 'any',
      hddDrop = 'any',
      lteDrop = 'any',
      graphicsDrop = 'any',
      category = 'none',
      bagColorDrop = 'any',
      bagBrandDrop = 'any',
      storeSizeDrop = 'any',
      printBrandDrop = 'any',
      printTypeDrop = 'any',
      otherTypeDrop = 'any';
  bool laptop = false,
      bags = false,
      printer = false,
      storage = false,
      other = false;

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

  void setSpecList() {
    specList = [
      screenDrop,
      bagBrandDrop,
      bagColorDrop,
      processorDrop,
      memoryDrop,
      hddDrop,
      lteDrop,
      graphicsDrop,
      storeSizeDrop,
      printBrandDrop,
      printTypeDrop,
      otherTypeDrop
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 15.0),
              child: Text(
                "WELCOME to our smart quotation system.\n"
                "How it works:\n"
                "Step 1 - Choose a tech category.\n"
                "Step 2 - Enter the specifics you would like the tech to have.\n"
                "Step 3 - All the tech we stock that have your custom specs will pop up below. You can add them straight to cart from here!",
                style: TextStyle(color: Colors.green, fontSize: 18),
              ),
            ),
          ],
        ),
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
                padding: const EdgeInsets.only(left: 15.0, bottom: 10),
                child: Container(
                  width: 150,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.green)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Category:'),
                      DropdownButton(
                        value: category,
                        icon: const Icon(Fryo.arrow_down),
                        iconSize: 20,
                        elevation: 16,
                        style:
                            TextStyle(fontSize: 12.0, color: Colors.blueGrey),
                        underline: Container(
                          height: 2,
                          color: Colors.green,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            category = newValue!;
                            setBool(category);
                            screenDrop = 'any';
                            processorDrop = 'any';
                            memoryDrop = 'any';
                            hddDrop = 'any';
                            lteDrop = 'any';
                            graphicsDrop = 'any';
                            bagColorDrop = 'any';
                            bagBrandDrop = 'any';
                            storeSizeDrop = 'any';
                            printBrandDrop = 'any';
                            printTypeDrop = 'any';
                            otherTypeDrop = 'any';
                            setSpecList();
                          });
                        },
                        items: <String>[
                          'none',
                          'bags',
                          'laptops',
                          'storage devices',
                          'printer',
                          'other'
                        ].map<DropdownMenuItem<String>>((String value) {
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
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 15.0),
          child: Text("HERE'S WHAT WE HAVE...", style: quoteText),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            height: 500,
            child: Column(
              children: [
                FutureBuilder(
                  future:
                      ApplicationService.getProdsForQuote(specList, category),
                  builder: (context, AsyncSnapshot<List<Product>> snapshot) {
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
                        if ((snapshot.data == null) ||
                            (category == 'none') ||
                            (snapshot.data?.length == 0)) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 100.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 70.0,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Fryo.sad,
                                      size: 60.0,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'No products match those specs!',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey,
                                          fontSize: 18.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Expanded(
                            child: GridView.builder(
                              itemBuilder: (context, index) {
                                return Center(
                                  child: productItem2(
                                    snapshot.data![index],
                                    onTapped: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return new ProductPage(
                                              productData: snapshot.data![index],
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                              itemCount: snapshot.data!.length,
                              gridDelegate:
                                  new SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                            ),
                          );
                        }
                      default:
                        return Text('default');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ////////////////////////////////////////////////////////////////////////
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 12.0),
          child: Text(
            "Still not quite what you are looking for? Enter your details and a short description of what you are looking for below. One of our sale consultants will get back to you with a full quote as soon as possible.",
            style: TextStyle(color: Colors.green, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 12.0),
          child: Text("PHONE NUMBER:", style: quoteText),
        ),
        Container(
          height: 35.0,
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Enter text...', border: InputBorder.none),
              keyboardType: TextInputType.text,
              maxLines: 1,
              controller: phoneController,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 12.0),
          child: Text("DESCRIPTION:", style: quoteText),
        ),
        Container(
          height: 100.0,
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Enter text...', border: InputBorder.none),
              keyboardType: TextInputType.multiline,
              maxLines: 17,
              controller: descriptionController,
            ),
          ),
        ),
        Center(
          child: SizedBox(
            height: 50,
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                phoneController.text.replaceAll('+', '0');
                if ((int.tryParse(phoneController.text) == null)) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Invalid phone number!'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else if (category == 'none') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Please choose a category first.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  descriptionString = setDescriptionString();
                  addQuote(descriptionString, Interface.user.getID);
                  String header = 'Quote Received';
                  String note =
                      'We have received your quote for a new $category product. '
                      'A sales consultant will get back to you as soon as possible. '
                      'Should you have any further questions please contact us at 011 466 3361';
                  sendNote(Interface.user.getID, header, note);
                  ApplicationService.sendMangerQuoteNote();
                  descriptionController.clear();
                  phoneController.clear();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Quote Sent'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text(
                "Submit",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      ],
    ));
  }

  String setDescriptionString() {
    switch (category) {
      case 'bags':
        return "${phoneController.text};$category;${specList[0]};${specList[1]};${specList[2]};${descriptionController.text}";
      case 'laptops':
        return "${phoneController.text};$category;${specList[3]};${specList[4]};${specList[5]};${specList[6]};${specList[7]};${descriptionController.text}";
      case 'storage devices':
        return "${phoneController.text};$category;${specList[8]};${descriptionController.text}";
      case 'printer':
        return "${phoneController.text};$category;${specList[9]};${specList[10]};${descriptionController.text}";
      case 'other':
        return "${phoneController.text};$category;${specList[11]};${descriptionController.text}";
      default:
        return 'default description';
    }
  }

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
                        onChanged: (String? newValue) {
                          setState(() {
                            screenDrop = newValue!;
                            setSpecList();
                          });
                        },
                        items: <String>['any', '13"', '14"', '15"', '17"']
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
                          onChanged: (String? newValue) {
                            setState(() {
                              processorDrop = newValue!;
                              setSpecList();
                            });
                          },
                          items: <String>['any', 'i3', 'i5', 'i7']
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
                          onChanged: (String? newValue) {
                            setState(() {
                              memoryDrop = newValue!;
                              setSpecList();
                            });
                          },
                          items: <String>['any', '8GB', '16GB', '32GB']
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
                          onChanged: (String? newValue) {
                            setState(() {
                              hddDrop = newValue!;
                              setSpecList();
                            });
                          },
                          items: <String>[
                            'any',
                            '256 SSD',
                            '512 SSD',
                            '1TB SSD'
                          ].map<DropdownMenuItem<String>>((String value) {
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
                          onChanged: (String? newValue) {
                            setState(() {
                              lteDrop = newValue!;
                              setSpecList();
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
                          onChanged: (String? newValue) {
                            setState(() {
                              graphicsDrop = newValue!;
                              setSpecList();
                            });
                          },
                          items: <String>['any', 'onboard', 'dedicated']
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
                      onChanged: (String? newValue) {
                        setState(() {
                          screenDrop = newValue!;
                          setSpecList();
                        });
                      },
                      items: <String>['any', '13"', '14"', '15"', '17"']
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
                        onChanged: (String? newValue) {
                          setState(() {
                            bagBrandDrop = newValue!;
                            setSpecList();
                          });
                        },
                        items: <String>['any', 'targus', 'lenovo']
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
                        onChanged: (String? newValue) {
                          setState(() {
                            bagColorDrop = newValue!;
                            setSpecList();
                          });
                        },
                        items: <String>['any', 'black', 'grey']
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
                      onChanged: (String? newValue) {
                        setState(() {
                          storeSizeDrop = newValue!;
                          setSpecList();
                          print(specList);
                        });
                      },
                      items: <String>['any', '1TB', '2TB', '4TB', '8TB']
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
                      onChanged: (String? newValue) {
                        setState(() {
                          printBrandDrop = newValue!;
                          setSpecList();
                        });
                      },
                      items: <String>['any', 'lexmark']
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
                        onChanged: (String? newValue) {
                          setState(() {
                            printTypeDrop = newValue!;
                            setSpecList();
                          });
                        },
                        items: <String>['any', 'black', 'color']
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
                      onChanged: (String? newValue) {
                        setState(() {
                          otherTypeDrop = newValue!;
                          setSpecList();
                        });
                      },
                      items: <String>['any', 'keyboard', 'docking station']
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
}

////////////////////////////////////////////////////////////////////////////////

Widget profileTab(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return myOrders();
                  }));
                },
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.white)),
                child: Row(
                  children: [
                    Icon(Fryo.book, color: Colors.black),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Orders',
                        style: TextStyle(fontSize: 12.0, color: Colors.black),
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
                Text(Interface.user.getName, style: TextStyle(fontSize: 12.0))
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
                Text(Interface.user.email, style: TextStyle(fontSize: 12.0))
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
                      WidgetStateProperty.all<Color>(Colors.white)),
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
                      WidgetStateProperty.all<Color>(Colors.white)),
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
  );
}
