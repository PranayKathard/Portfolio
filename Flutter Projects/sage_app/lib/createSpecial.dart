import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:sage/src/Models/product.dart';
import 'package:sage/src/shared/colors.dart';
import 'package:sage/src/shared/fryo_icons.dart';
import 'package:flutter/material.dart';
import 'package:sage/src/shared/styles.dart';
import 'src/Services/application_service.dart';

class createSpecial extends StatefulWidget {
  @override
  _createSpecialState createState() => _createSpecialState();
}

class _createSpecialState extends State<createSpecial> {
  static const historyLength = 5;
  late Future<List<Product>> products;

  // Future<List<Product>> _getProds() async {
  //   return await ApplicationService.fetchForDelete(s);
  // }

  List<String> _searchHistory = [];

  late List<String> filteredSearchHistory;

  late String selectedTerm;

  get key => null;

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
        centerTitle: true,
        title: Text('Create Special'),
        backgroundColor: primaryColor,
      ),
      body: FloatingSearchBar(
        automaticallyImplyBackButton: false,
        controller: controller,
        body: FloatingSearchBarScrollNotifier(
          child: SearchResultsListView(
            searchTerm: selectedTerm,
            prods: products, key: key,
          ),
        ),
        transition: CircularFloatingSearchBarTransition(),
        physics: BouncingScrollPhysics(),
        title: Text(
          selectedTerm,
          style: h6,
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
                        'Search for a product to add a special',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
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
  final Future<List<Product>> prods;
  final TextEditingController controller = TextEditingController();

  SearchResultsListView({
    required Key key,
    required this.searchTerm,
    required this.prods,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder(
            future: ApplicationService.fetchForDelete(searchTerm),
            builder: (context, AsyncSnapshot<List<Product>> snapshot) {
              print(snapshot.hasData);
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('none');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Text('Loading...');
                case ConnectionState.done:
                  if (snapshot.data?.length == 0) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 70.0,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Fryo.search,
                              size: 60.0,
                              color: Colors.blueGrey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Search for a product to add a special...',
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
                    return Flexible(
                      fit: FlexFit.loose,
                      child: ListView.separated(
                          padding:
                              EdgeInsets.only(top: 20, left: 20, right: 20),
                          itemBuilder: (context, index) {
                            return Container(
                              height: 70,
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: Text(
                                                'Please enter the percentage to create the sale'),
                                            content: TextField(
                                              controller: controller,
                                            ),
                                            actions: <Widget>[
                                              MaterialButton(
                                                elevation: 5.0,
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context, 'Cancel');
                                                },
                                              ),
                                              MaterialButton(
                                                elevation: 5.0,
                                                child: Text('Confirm'),
                                                onPressed: () {
                                                  if (double.tryParse(
                                                          controller.text) ==
                                                      null) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                              title: const Text(
                                                                  'Please enter a valid decimal value'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context,
                                                                        'OK');
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'OK'),
                                                                ),
                                                              ],
                                                            ));
                                                  } else {
                                                    snapshot.data?[index]
                                                            .discount =
                                                        double.parse(
                                                            controller.text);
                                                    ApplicationService
                                                        .setSpecial(snapshot
                                                            .data![index]);
                                                    Navigator.pop(
                                                        context, 'Confirm');
                                                  }
                                                },
                                              )
                                            ],
                                          ));
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.pressed))
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
                                    Text(
                                      snapshot.data![index].name,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                    Image.asset(
                                      "images/" + snapshot.data![index].getImage,
                                      width: 50,
                                      height: 50,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                                color: Colors.white,
                              ),
                          itemCount: snapshot.data!.length),
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
}
