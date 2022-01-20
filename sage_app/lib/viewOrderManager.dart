import 'package:flutter_icons/flutter_icons.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:sage/QuotePage.dart';
import 'package:sage/src/Models/order.dart';
import 'package:sage/src/Services/application_service.dart';
import 'package:flutter/material.dart';
import 'OrderManger.dart';
import 'src/Services/service.dart';
import 'package:sage/src/Models/quote.dart';

class viewOrdersManager extends StatefulWidget {
  viewOrdersManager({Key key}) : super(key: key);

  @override
  _viewOrdersManagerState createState() => _viewOrdersManagerState();
}

class _viewOrdersManagerState extends State<viewOrdersManager> {
  static const historyLength = 5;
  Future<List<Order>> orders;

  Future<List<Order>> _getOrders() async {
    return await ApplicationService.getOrdersForManager();
  }

  List<String> _searchHistory = [];

  List<String> filteredSearchHistory;

  String selectedTerm = '';

  List<String> filterSearchTerms({
    String filter,
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

  FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: '');
    orders = _getOrders();
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
        centerTitle: true,
        title: Text('Current Orders'),
        backgroundColor: Color(0xff99BC1C),
      ),
      body: FloatingSearchBar(
        automaticallyImplyBackButton: false,
        controller: controller,
        body: FloatingSearchBarScrollNotifier(
          child: SearchResultsListView(
            searchTerm: selectedTerm,
            ords: orders,
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
                        'Search for a order using order ID',
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
    );
  }
}

class SearchResultsListView extends StatelessWidget {
  final String searchTerm;
  Future<List<Order>> ords; //change to order

  SearchResultsListView({
    this.searchTerm,
    this.ords,
  }) : super();

  @override
  Widget build(BuildContext context) {
    if (searchTerm == '') {
      return Padding(
        padding: const EdgeInsets.only(top: 80),
        child: FutureBuilder(
          future: ApplicationService.getOrdersForManager(),
          builder: (context, AsyncSnapshot<List<Order>> snapshot) {
            print(snapshot.hasData);
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('none');
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Text('Loading...');
              case ConnectionState.done:
                if (!snapshot.hasData) {
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
                            'Currently there are no orders...',
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
                  return ListView.separated(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      itemBuilder: (context, index) {
                        if (snapshot.data[index].completed == 0) {
                          return Container(
                            height: 70,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return new OrderManager(
                                        orderData: snapshot.data[index],
                                      );
                                    },
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Colors.white;
                                    return Colors
                                        .white; // Use the component's default.
                                  },
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order #' +
                                            snapshot.data[index].orderID
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                      Text(
                                        'Client : ' +
                                            snapshot.data[index].userId
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.green),
                                      ),
                                      Flexible(
                                        child: Container(
                                          width: 200,
                                          child: Text(
                                            'Total :R ' +
                                                snapshot.data[index].totalPrice
                                                    .toStringAsFixed(2),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.lightGreen),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            height: 70,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return new OrderManager(
                                        orderData: snapshot.data[index],
                                      );
                                    },
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Colors.white;
                                    return Colors
                                        .grey; // Use the component's default.
                                  },
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order #' +
                                            snapshot.data[index].orderID
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                      Text(
                                        'Client : ' +
                                            snapshot.data[index].userId
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.green),
                                      ),
                                      Flexible(
                                        child: Container(
                                          width: 200,
                                          child: Text(
                                            'Total :R ' +
                                                snapshot.data[index].totalPrice
                                                    .toStringAsFixed(2),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.lightGreen),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                      separatorBuilder: (context, index) => Divider(
                            color: Colors.white,
                          ),
                      itemCount: snapshot.data.length);
                }
                break;
              default:
                return Text('default');
            }
          },
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: FutureBuilder(
        future: ApplicationService.fetchOrders(searchTerm),
        builder: (context, AsyncSnapshot<List<Order>> snapshot) {
          print(snapshot.hasData);
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('none');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: Text('Loading...'));
            case ConnectionState.done:
              if (!snapshot.hasData) {
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
                          'No order found...',
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
                return ListView.separated(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    itemBuilder: (context, index) {
                      if (snapshot.data[index].completed == 0) {
                        return Container(
                          height: 70,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return new OrderManager(
                                      orderData: snapshot.data[index],
                                    );
                                  },
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Colors.white;
                                  return Colors
                                      .white; // Use the component's default.
                                },
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order #' +
                                          snapshot.data[index].orderID
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                    Text(
                                      'Client : ' +
                                          snapshot.data[index].userId
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.green),
                                    ),
                                    Flexible(
                                      child: Container(
                                        width: 200,
                                        child: Text(
                                          'Total :R ' +
                                              snapshot.data[index].totalPrice
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.lightGreen),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          height: 70,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return new OrderManager(
                                      orderData: snapshot.data[index],
                                    );
                                  },
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Colors.white;
                                  return Colors
                                      .grey; // Use the component's default.
                                },
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order #' +
                                          snapshot.data[index].orderID
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                    Text(
                                      'Client : ' +
                                          snapshot.data[index].userId
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.green),
                                    ),
                                    Flexible(
                                      child: Container(
                                        width: 200,
                                        child: Text(
                                          'Total :R ' +
                                              snapshot.data[index].totalPrice
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.lightGreen),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    separatorBuilder: (context, index) => Divider(
                          color: Colors.white,
                        ),
                    itemCount: snapshot.data.length);
              }
              break;
            default:
              return Text('default');
          }
        },
      ),
    );
  }
}
