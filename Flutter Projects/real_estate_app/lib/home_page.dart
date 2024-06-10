import 'dart:async';
import 'dart:developer';

import 'package:dtt_assessment/about_page.dart';
import 'package:dtt_assessment/house_detail_page.dart';
import 'package:dtt_assessment/service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:dtt_assessment/abstract.dart';
import 'package:sizer/sizer.dart';

import 'house.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  /*LIST OF HOUSES*/
  Future<List<House>>? houses;

  /*SEARCH BAR*/
  final TextEditingController searchController = TextEditingController();

  void onSearchChanged() {
    setState(() {
      houses = searchHouses(searchController.text);
    });
  }

  /*FILTER*/
  //Update list view
  void onFilter(int sortPrice, double bedSlider, double bathSlider){
    setState(() {
      houses = filterPrice(sortPrice, bedSlider, bathSlider);
    });
  }

  int selectedFilter = 0;
  double bedSliderValue = 1.0;
  double bathSliderValue = 1.0;

  //Pop up for filter
  void showRadioDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        //Used StatefulBuilder because showDialog does not automatically build the parent widgets state
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return AlertDialog(
              title: const Text('Filter by', style: title01,),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    //Order by price increasing
                    RadioListTile<int>(
                      title: const Text('Price(lowest)', style: body,),
                      value: 0,
                      groupValue: selectedFilter,
                      onChanged: (int? value) {
                        setState(() {
                          selectedFilter = value!;
                        });
                      },
                    ),
                    //Order by price decreasing
                    RadioListTile<int>(
                      title: const Text('Price(highest)', style: body,),
                      value: 1,
                      groupValue: selectedFilter,
                      onChanged: (int? value){
                        setState(() {
                          selectedFilter = value!;
                        });
                      },
                    ),
                    //Choose no. beds
                    Slider(
                      value: bedSliderValue,
                      min: 1.0,
                      max: 6.0,
                      divisions: 5,
                      label: bedSliderValue.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          bedSliderValue = value.roundToDouble();
                        });
                      },
                    ),
                    Text(
                      'Min Bedrooms: $bedSliderValue',
                      style: body,
                    ),
                    //Choose no. baths
                    Slider(
                      value: bathSliderValue,
                      min: 1.0,
                      max: 6.0,
                      divisions: 5,
                      label: bathSliderValue.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          bathSliderValue = value.roundToDouble();
                        });
                      },
                    ),
                    Text(
                      'Min Bathrooms: $bathSliderValue',
                      style: body,
                    ),
                  ]
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Apply', style: title03,),
                  onPressed: () {
                    onFilter(selectedFilter, bedSliderValue, bathSliderValue);
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Close', style: title03,),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  /*BOTTOM NAVIGATION BAR*/
  int selectedBottomIndex = 0 ;

  static const List<Widget> pages = <Widget>[
    HomePage(),
    AboutHouse()
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedBottomIndex = index;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
      builder: (BuildContext context) {
        return pages[selectedBottomIndex];
      },
    ));
  }

  /*LOCATION*/
  //Instantiate currentPosition with a default so NULL error doesn't display while position is being fetched
  late Position currentPosition = Position(longitude: 0, latitude: 0, timestamp: DateTime.timestamp(), accuracy: 0, altitude: 0, altitudeAccuracy: 0, heading: 0, headingAccuracy: 0, speed: 0, speedAccuracy: 0);
  late LocationPermission permission;
  bool locationDenied = true;

  //Try get the location, option to deny available
  Future<void> getCurrentPosition() async {
    permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      //App does not have permission.
      locationDenied = true;
    }else if(permission == LocationPermission.deniedForever || permission == LocationPermission.unableToDetermine){
      //Open settings for the user.
      Geolocator.openAppSettings();
    }else{
      //App has permission. Get the devices location.
      locationDenied = false;
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        );
        setState(() {
          currentPosition = position;
        });
      } catch (e) {
        log(e.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
    houses = getHouses();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    super.dispose();
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
  }

  /*BUILD*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          color: const Color(0xffF7F7F7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /*Heading and filter*/
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(22,7.h,22,10),
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'DTT REAL ESTATE',
                        style: TextStyle(
                          fontFamily: 'Gotham SSm',
                          fontSize: 18,
                          color: Color(0xff313131)
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0,5.5.h,22,0),
                    child: IconButton(
                        onPressed: (){
                          showRadioDialog();
                        },
                        icon: const Icon(Icons.filter_list)),
                  )
                ],
              ),
              /*Search bar*/
              Padding(
                padding: const EdgeInsets.fromLTRB(22,15,22,0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xffEBEBEB)),
                  child: SearchBar(
                    controller: searchController,
                    elevation: const WidgetStatePropertyAll<double>(0.0),
                    trailing: <Widget>[
                      searchSVG
                    ],
                    backgroundColor: const WidgetStatePropertyAll<Color>(Color(0xffEBEBEB)),
                    hintText: 'Search for a home',
                    hintStyle: const WidgetStatePropertyAll<TextStyle>(
                        TextStyle(color: Color(0xff949494))
                    ),
                  ),
                )
              ),
              /*List of houses*/
              Expanded(
                child: FutureBuilder(
                  future: houses,
                  builder: (BuildContext context, AsyncSnapshot<List<House>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return const Center(child: Text('No data.'));
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        //Don't show NULL error while loading
                        return const Center(child: Text('Loading...', style: title03,));
                      case ConnectionState.done:
                        //Handle no internet connection
                        if(snapshot.data == null){
                          return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('No data.\n Please check your internet connection.', textAlign: TextAlign.center, style: title03,),
                                  Icon(Icons.signal_wifi_connected_no_internet_4_outlined, size: 100,)
                                ],
                              ));
                        }
                        //Handle empty search
                        else if (snapshot.data!.isEmpty){
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 300,
                                  width: 300,
                                  child: Image.asset(
                                      'assets/Images/search_state_empty.png')
                              ),
                              const Text(
                                'No results found!\n Perhaps try another search?',
                                style: TextStyle(
                                    fontFamily: 'Gotham SSm',
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xffB0B0B0)
                                ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          );
                        }
                        //Show list of houses
                        else {
                          return ListView.builder(
                            padding: const EdgeInsets.fromLTRB(22,22,22,22),
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              //Format price
                              String formattedPrice = NumberFormat.decimalPattern().
                                format(int.parse(snapshot.data![index].price));

                              //Calculate distance away. If it is -1 then location has been denied
                              double distanceAway;
                              if(locationDenied){
                                distanceAway = -1;
                              }else{
                                distanceAway = calculateDistanceAway(
                                    currentPosition.latitude,
                                    currentPosition.longitude,
                                    double.parse(snapshot.data![index].latitude),
                                    double.parse(snapshot.data![index].longitude)
                                );
                              }
                                return Container(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  height: 125,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        spreadRadius: 10,
                                        blurRadius: 10,
                                        //Changes position of shadow
                                        offset: const Offset(
                                            0, 3),
                                      ),
                                    ],
                                  ),
                                  //When house is clicked navigate to detail page
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return HouseDetail(
                                              house: snapshot.data![index],
                                              calculatedDistance: distanceAway,
                                            );
                                          },
                                        ));
                                      },
                                    child: Card(
                                        elevation: 0,
                                        color: const Color(0xffFFFFFF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 15, 15, 15),
                                          child: Row(
                                              children: [
                                                /*Picture of house*/
                                                ClipRRect(
                                                    borderRadius: BorderRadius
                                                        .circular(16),
                                                    child: SizedBox(
                                                      height: 90,
                                                      width: 90,
                                                      child: Image.network(
                                                        rootImage + snapshot.data![index].image,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    )
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Column(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        /*Price and location*/
                                                        Align(
                                                          alignment: Alignment
                                                              .topLeft,
                                                          child: Padding(
                                                            padding: const EdgeInsets
                                                                .only(left: 25.0),
                                                            child: RichText(
                                                              text: TextSpan(
                                                                  children: [
                                                                    textSpan(
                                                                        '\$$formattedPrice\n',
                                                                        22,
                                                                        const Color(0xff313131),
                                                                        FontWeight.w500),
                                                                    textSpan(
                                                                        '${snapshot.data?[index].zip.replaceAll(' ', '')} ${snapshot.data?[index].city}\n',
                                                                        12,
                                                                        const Color(0xff949494),
                                                                        FontWeight.w400),
                                                                  ]
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        /*Icons with metrics*/
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceEvenly,
                                                          children: [
                                                            iconRowWidget(
                                                                bedSVG,
                                                                snapshot.data![index].bedrooms.toString()),
                                                            iconRowWidget(
                                                                bathSVG,
                                                                snapshot.data![index].bathrooms.toString()),
                                                            iconRowWidget(
                                                                sizeSVG,
                                                                snapshot.data![index].size.toString()),
                                                            iconRowWidget(
                                                                locationSVG,
                                                                //If location denied then display '?' else display distance
                                                                locationDenied?'? km': '${distanceAway.toStringAsFixed(1)} km'
                                                            )
                                                          ],
                                                        )
                                                      ]
                                                  ),
                                                )
                                              ]
                                          ),
                                        )
                                    ),
                                  ),
                                );
                            },
                          );
                        }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xffFFFFFF),
        onTap: onItemTapped,
        currentIndex: selectedBottomIndex,
        items: <BottomNavigationBarItem>[
          bottomNavBarItem(houseSVG, houseActiveSVG),
          bottomNavBarItem(infoSVG, infoActiveSVG)
        ],
      ),
    );
  }

}
