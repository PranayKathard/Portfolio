import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:sage/QuotePage.dart';
import 'package:sage/src/Services/application_service.dart';
import 'package:flutter/material.dart';
import 'src/Services/service.dart';
import 'package:sage/src/Models/quote.dart';

class ViewQuote extends StatefulWidget {
  ViewQuote({Key key}) : super(key: key);

  @override
  _ViewQuoteState createState() => _ViewQuoteState();
}

class _ViewQuoteState extends State<ViewQuote> {
  static const historyLength = 5;
  Future<List<Quote>> quotes;

  // Future<List<Product>> _getProds() async {
  //   return await ApplicationService.fetchForDelete(s);
  // }

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
        title: Text('Pending Quotes'),
        backgroundColor: Color(0xff99BC1C),
      ),
      body: FloatingSearchBar(
        automaticallyImplyBackButton: false,
        controller: controller,
        body: FloatingSearchBarScrollNotifier(
          child: SearchResultsListView(
            searchTerm: selectedTerm,
            quos: quotes,
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
    );
  }
}

class SearchResultsListView extends StatelessWidget {
  final String searchTerm;
  Future<List<Quote>> quos;

  SearchResultsListView({
    this.searchTerm,
    this.quos,
  }) : super();

  @override
  Widget build(BuildContext context) {
    if (searchTerm == '') {
      return Padding(
        padding: const EdgeInsets.only(top: 80),
        child: FutureBuilder(
          future: Service.getQuotes(),
          builder: (context, AsyncSnapshot<List<Quote>> snapshot) {
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
                            'Currently there are no quotes...',
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
                        return Container(
                          height: 70,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return new QuotePage(
                                      quoteData: snapshot.data[index],
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
                                      'Ticket number: ' +
                                          snapshot.data[index].getID.toString(),
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      'Users ID: ' +
                                          snapshot.data[index].getUserID
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.green),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
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
        future: ApplicationService.fetchQuotes(searchTerm),
        builder: (context, AsyncSnapshot<List<Quote>> snapshot) {
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
                          'No quote found...',
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
                      return Container(
                        height: 70,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return new QuotePage(
                                    quoteData: snapshot.data[index],
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
                                    'Ticket number: ' +
                                        snapshot.data[index].getID.toString(),
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Users ID: ' +
                                        snapshot.data[index].getUserID
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.green),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
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
