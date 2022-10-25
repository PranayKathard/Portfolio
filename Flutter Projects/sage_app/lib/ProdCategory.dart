import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sage/searchProduct.dart';
import 'package:sage/src/shared/colors.dart';
import 'package:sage/src/shared/fryo_icons.dart';
import 'package:sage/src/shared/partials.dart';
import 'package:sage/src/shared/styles.dart';
import 'ProductPage.dart';
import 'src/Models/product.dart';
import 'src/Services/service.dart';

class ProdCategory extends StatefulWidget {
  final int category;

  const ProdCategory({Key key, this.category}) : super(key: key);
  @override
  _ProdCategoryState createState() => _ProdCategoryState();
}

class _ProdCategoryState extends State<ProdCategory>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 6, vsync: this, initialIndex: widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Products',
            style: logoWhiteStyle, textAlign: TextAlign.center),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return new SearchProduct();
                    },
                  ),
                );
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: Container(
        width: 5000,
        child: ListView(
          //future builder.
          padding: EdgeInsets.only(left: 10.0),
          children: <Widget>[
            SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.all(18.00),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Fryo.screen, size: 30.0, color: Colors.black),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.transparent,
                labelColor: Color(0xFF3CD30D),
                isScrollable: true,
                labelPadding: EdgeInsets.all(10),
                unselectedLabelColor: Color(0xFF000000),
                tabs: [
                  tabbarTab('All'),
                  tabbarTab('Bags'),
                  tabbarTab('Laptops'),
                  tabbarTab('Storage Devices'),
                  tabbarTab('Printers'),
                  tabbarTab('Other'),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                      height: MediaQuery.of(context).size.height - 50.0,
                      width: double.infinity,
                      child: TabBarView(controller: _tabController, children: [
                        viewProducts(),
                        viewProdCat("Bags"),
                        viewProdCat("Laptops"),
                        viewProdCat("Storage Devices"),
                        viewProdCat("Printer"),
                        viewProdCat("Other"),
                      ])),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Tab tabbarTab(String s) {
    return Tab(
      child: Center(
        child: Text(
          s,
          style: TextStyle(
              color: Color(0xff444444),
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              fontSize: 18.0),
        ),
      ),
    );
  }

  viewProdCat(String category) {
    Future<List<Product>> catProds = Service.getCategoryProducts(category);
    return Column(
      children: [
        FutureBuilder(
          future: catProds,
          builder: (context, AsyncSnapshot<List<Product>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('none');
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Text('Active and waiting...');
              case ConnectionState.done:
                return Expanded(
                  child: GridView.builder(
                    itemBuilder: (context, index) {
                      return Center(
                        child: productItem2(
                          snapshot.data[index],
                          onTapped: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return new ProductPage(
                                    productData: snapshot.data[index],
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                    itemCount: snapshot.data.length,
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

  viewProducts() {
    Future<List<Product>> prods = Service.getProducts();
    return Column(
      children: [
        FutureBuilder(
          future: prods,
          builder: (context, AsyncSnapshot<List<Product>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('none');
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Text('Active and waiting...');
              case ConnectionState.done:
                return Expanded(
                  child: GridView.builder(
                    itemBuilder: (context, index) {
                      return Center(
                        child: productItem2(
                          snapshot.data[index],
                          onTapped: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return new ProductPage(
                                    productData: snapshot.data[index],
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                    itemCount: snapshot.data.length,
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
