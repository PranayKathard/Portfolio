import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:sage_mobile/Dashboard.dart';
import 'package:sage_mobile/product_page.dart';
import 'package:sage_mobile/services/service.dart';
import 'package:sage_mobile/style/fryo_icons.dart';
import 'package:sage_mobile/style/stylesheet.dart';
import 'burgerMenuOptions/cartPage.dart';
import 'models/product.dart';
import 'services/application_service.dart';

class Catalogue extends StatefulWidget {
  static late String categoryDrop = 'All';
  static late String priceRange = 'All';
  @override
  _CatalogueState createState() => _CatalogueState();
}

class _CatalogueState extends State<Catalogue> {
  static const historyLength = 5;

  List<String> _searchHistory = [];

  late List<String> filteredSearchHistory;

  late String selectedTerm = '';

  List<String> filterSearchTerms({
    required String filter,
  }) {
    if (filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }

    filteredSearchHistory = filterSearchTerms(filter: '');
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: '');
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  late FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: '');
    //products = _getProds();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text(
          'catalogue',
          style: logoWhiteStyle,
        ),
        backgroundColor: Color(0xff99BC1C),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FloatingSearchBar(
              automaticallyImplyDrawerHamburger: false,
              automaticallyImplyBackButton: false,
              controller: controller,
              body: FloatingSearchBarScrollNotifier(
                child: SearchResultsGridView(
                  searchTerm: selectedTerm,
                ),
              ),
              transition: CircularFloatingSearchBarTransition(),
              physics: BouncingScrollPhysics(),
              title: Text(
                selectedTerm,
                style: Theme.of(context).textTheme.headline6,
              ),
              hint: 'Search...',
              actions: [
                FloatingSearchBarAction.searchToClear(),
              ],
              onQueryChanged: (query) {
                setState(() {
                  filteredSearchHistory = filterSearchTerms(filter: query);
                });
              },
              onSubmitted: (query) {
                setState(() {
                  addSearchTerm(query);
                  selectedTerm = query;
                });
                controller.close();
              },
              builder: (context, transition) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Material(
                    color: Colors.white,
                    elevation: 4,
                    child: Builder(
                      builder: (context) {
                        if (filteredSearchHistory.isEmpty &&
                            controller.query.isEmpty) {
                          return Container(
                            height: 56,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              'Search for a quote using ID',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          );
                        } else if (filteredSearchHistory.isEmpty) {
                          return ListTile(
                            title: Text(controller.query),
                            leading: const Icon(Icons.search),
                            onTap: () {
                              setState(() {
                                addSearchTerm(controller.query);
                                selectedTerm = controller.query;
                              });
                              controller.close();
                            },
                          );
                        } else {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: filteredSearchHistory
                                .map(
                                  (term) => ListTile(
                                    title: Text(
                                      term,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    leading: const Icon(Icons.history),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          deleteSearchTerm(term);
                                        });
                                      },
                                    ),
                                    onTap: () {
                                      setState(() {
                                        putSearchTermFirst(term);
                                        selectedTerm = term;
                                      });
                                      controller.close();
                                    },
                                  ),
                                )
                                .toList(),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Center(
                  child: Text('preferences',
                      style: logoWhiteStyle, textAlign: TextAlign.center)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Categories:'),
                SizedBox(
                  width: 10,
                ),
                DropdownButton(
                  value: Catalogue.categoryDrop,
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
                      Catalogue.categoryDrop = newValue!;
                    });
                  },
                  items: <String>[
                    'All',
                    'Bags',
                    'Laptops',
                    'Storage Devices',
                    'Printers',
                    'Other'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Price Range:'),
                SizedBox(
                  width: 10,
                ),
                DropdownButton(
                  value: Catalogue.priceRange,
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
                      Catalogue.priceRange = newValue!;
                    });
                  },
                  items: <String>[
                    'All',
                    '0-1000',
                    '1000-1999',
                    '2000-2999',
                    '3000-3999',
                    '4000-4999',
                    '5000-5999',
                    '6000-6999',
                    '7000-7999',
                    '8000-8999',
                    '9000-9999',
                    '10000+'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class SearchResultsGridView extends StatelessWidget {
  final String searchTerm;

  SearchResultsGridView({
    required this.searchTerm,
  }) : super();

  @override
  Widget build(BuildContext context) {
    if (searchTerm == '') {
      return Padding(
        padding: const EdgeInsets.only(top: 60),
        child: FutureBuilder(
          future: ApplicationService.fetchForCatalogue(
              Catalogue.categoryDrop, Catalogue.priceRange),
          builder: (context, AsyncSnapshot<List<Product>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('none');
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Text('Loading...');
              case ConnectionState.done:
                if (snapshot.data!.length == 0) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 70.0,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.search,
                            size: 60.0,
                            color: Colors.blueGrey,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Currently there are no products with those specifications...',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                                fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return GridView.builder(
                    padding: EdgeInsets.only(bottom: 1),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Center(
                        child: productItemNoSale(
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
                          imgWidth: 75,
                        ),
                      );
                    },
                    itemCount: snapshot.data!.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                  );
                }
              default:
                return Text('default');
            }
          },
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: FutureBuilder(
        future: ApplicationService.fetchForSearch(searchTerm),
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          print(snapshot.hasData);
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('none');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text('Loading...');
            case ConnectionState.done:
              if (snapshot.data!.length == 0) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 70.0,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.search,
                          size: 60.0,
                          color: Colors.blueGrey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Search for a product...',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                              fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Center(
                      child: productItemNoSale(
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
                        imgWidth: 75,
                      ),
                    );
                  },
                  itemCount: snapshot.data!.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                );
              }
            default:
              return Text('default');
          }
        },
      ),
    );
  }
}
