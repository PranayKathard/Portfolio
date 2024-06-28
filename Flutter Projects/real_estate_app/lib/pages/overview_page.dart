import 'dart:async';
import 'dart:developer';

import 'package:dtt_assessment/bloc/filter_cubit.dart';
import 'package:dtt_assessment/bloc/house_cubit.dart';
import 'package:dtt_assessment/pages/house_detail_page.dart';
import 'package:dtt_assessment/logic/service.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:dtt_assessment/widgets/abstract.dart';
import 'package:sizer/sizer.dart';

import '../object/house.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage>{

  /*LIST OF HOUSES*/
  late List<House> houses;
  //Controller required for faded scrolling
  late ScrollController scrollController;

  /*SEARCH BAR*/
  final TextEditingController searchController = TextEditingController();
  //Check if there is text in the searchbar
  bool showCloseButton = false;

  //To be done when searchbar is closed
  void closeKeyboard() {
    setState(() {
      searchController.clear();
      showCloseButton = false;
    });
    //Unfocused to hide the keyboard
    FocusScope.of(context).unfocus();
    context.read<HouseCubit>().fetchHouses();
  }

  /*FILTER*/
  //Update list view with filtered options
  void onFilter(int sortPrice, double bedSlider, double bathSlider){
    context.read<HouseCubit>().filterHouses(sortPrice,bedSlider,bathSlider);
  }

  //Filter tracking values
  int sortBit = 0;
  double bedSliderValue = 1.0;
  double bathSliderValue = 1.0;

  //Pop up for filter
  void showRadioDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        //This BlocBuilder is used to manage to state of the filter components
        return BlocBuilder<FilterCubit, FilterState>(
          builder: (context, state){
            switch(state){
              case FilterApplied():
                sortBit = (state).sortBit;
                bedSliderValue = (state).beds;
                bathSliderValue = (state).baths;
                return AlertDialog(
                  title: const Text('Filter by', style: title01,),
                  content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        //Order by price increasing
                        RadioListTile<int>(
                          title: const Text('Price(lowest)', style: body,),
                          value: 0,
                          groupValue: sortBit,
                          onChanged: (value) {
                            //Show live change of price sort
                            context.read<FilterCubit>().changeFilter(value!, bedSliderValue, bathSliderValue);
                          },
                        ),
                        //Order by price decreasing
                        RadioListTile<int>(
                          title: const Text('Price(highest)', style: body,),
                          value: 1,
                          groupValue: sortBit,
                          onChanged: (value){
                            //Show live change of price sort
                            context.read<FilterCubit>().changeFilter(value!, bedSliderValue, bathSliderValue);
                          },
                        ),
                        //Choose number of beds
                        Slider(
                          value: bedSliderValue,
                          min: 1.0,
                          max: 6.0,
                          divisions: 5,
                          label: bedSliderValue.round().toString(),
                          onChanged: (value) {
                            //Show live changes to bed slider
                            context.read<FilterCubit>().changeFilter(sortBit, value, bathSliderValue);
                          },
                        ),
                        Text(
                          'Min Bedrooms: $bedSliderValue',
                          style: body,
                        ),
                        //Choose number of baths
                        Slider(
                          value: bathSliderValue,
                          min: 1.0,
                          max: 6.0,
                          divisions: 5,
                          label: bathSliderValue.round().toString(),
                          onChanged: (value) {
                            //Show live changes to bath slider
                            context.read<FilterCubit>().changeFilter(sortBit, bedSliderValue, value);
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
                        //Call method to update list based on filter values
                        onFilter(sortBit, bedSliderValue, bathSliderValue);
                        Navigator.of(context).pop();
                      },
                    ),
                    //Close button
                    TextButton(
                      child: const Text('Close', style: title03,),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
            }
          },
        );
      },
    );
  }

  /*LOCATION*/
  //Instantiate currentPosition with a default so NULL error doesn't display while position is being fetched
  late Position currentPosition = Position(longitude: 0, latitude: 0, timestamp: DateTime.timestamp(), accuracy: 0, altitude: 0, altitudeAccuracy: 0, heading: 0, headingAccuracy: 0, speed: 0, speedAccuracy: 0);
  //Variable to track location permission
  late LocationPermission permission;
  //Variable to track if location has been denied
  bool locationDenied = true;

  //Try get the location, option to deny available
  Future<void> getCurrentPosition() async {
    permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      //App does not have permission.
      locationDenied = true;
    }else if(permission == LocationPermission.deniedForever || permission == LocationPermission.unableToDetermine){
      //Open settings for the user if permission permanently denied.
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
    //Get device location
    getCurrentPosition();
    //Scroll controller for list fading
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    scrollController.dispose();
  }

  /*BUILD*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          //Stretch container across device width
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
                  //Button to display filter
                  Padding(
                    padding: EdgeInsets.fromLTRB(0,5.5.h,22,0),
                    child: IconButton(
                        onPressed: (){
                          //Display the filter popup
                          showRadioDialog();
                        },
                        icon: const Icon(Icons.filter_list)),
                  )
                ],
              ),
              /*Search bar*/
              Padding(
                padding: const EdgeInsets.fromLTRB(22,22,22,0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xffEBEBEB)),
                  child: SearchBar(
                    controller: searchController,
                    onChanged: (query){
                      //Access house cubit state
                      context.read<HouseCubit>().searchHouses(query);
                      //Show close button when typing
                      setState(() {
                        showCloseButton = true;
                      });
                    },
                    elevation: const WidgetStatePropertyAll<double>(0.0),
                    //Trailing icon dependant on text controller
                    trailing: !showCloseButton ? <Widget>[searchSVG]:
                    <Widget>[IconButton(onPressed: (){
                      closeKeyboard();
                      }, icon: closeSVG)],
                    backgroundColor: const WidgetStatePropertyAll<Color>(Color(0xffEBEBEB)),
                    hintText: 'Search for a home',
                    hintStyle: const WidgetStatePropertyAll<TextStyle>(
                        TextStyle(color: Color(0xff949494))
                    ),
                  ),
                )
              ),
              const SizedBox(
                height: 12,
              ),
              /*List of houses*/
              Expanded(
                child: BlocBuilder<HouseCubit, HouseState>(
                  builder: (context, state) {
                    switch (state) {
                      //Handel no internet connection
                      case HouseError():
                        return const Center(child: Text(
                          'No internet.\n Please check your connection.',
                          textAlign: TextAlign.center,)
                        );
                      case HouseInitial():
                      case HouseLoading():
                        //Alert user that list of houses is loading
                        return const Center(child: Text('Loading...', style: title03,));
                      case HouseLoaded() || HouseSearched() || HouseFiltered():
                        //Populate houses based on action
                        if(state is HouseLoaded){
                          houses = state.houses;
                        }else if (state is HouseFiltered){
                          houses = state.filteredHouses;
                        }else if (state is HouseSearched){
                          houses = state.searchedHouses;
                        }
                        //Handle empty search 
                        if(houses.isEmpty){
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
                        //Show list of houses with fading effect on top and bottom
                        else {
                          return FadingEdgeScrollView.fromScrollView(
                            gradientFractionOnStart: 0.1,
                            gradientFractionOnEnd: 0.05,
                            child: ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.fromLTRB(22,18,22,22),
                              scrollDirection: Axis.vertical,
                              itemCount: houses.length,
                              itemBuilder: (BuildContext context, int index) {
                                //Format price
                                String formattedPrice = NumberFormat.decimalPattern().
                                  format(int.parse(houses[index].price));
                            
                                //Calculate distance away. If it is -1(denied) then location has been denied
                                double distanceAway;
                                if(locationDenied){
                                  distanceAway = -1;
                                }else{
                                  distanceAway = calculateDistanceAway(
                                      currentPosition.latitude,
                                      currentPosition.longitude,
                                      double.parse(houses[index].latitude),
                                      double.parse(houses[index].longitude)
                                  );
                                }
                                //Container necessary for box shadow effect around card
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
                                                house: houses[index],
                                                calculatedDistance: distanceAway,
                                              );
                                            },
                                          ));
                                        },
                                      //Display house info in a card
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
                                                          rootImage + houses[index].image,
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
                                                                  .only(left: 14.0),
                                                              //RichText allowing a span of texts with different styles
                                                              child: RichText(
                                                                text: TextSpan(
                                                                    children: [
                                                                      textSpan(
                                                                          '\$$formattedPrice\n',
                                                                          22,
                                                                          const Color(0xff313131),
                                                                          FontWeight.w500),
                                                                      textSpan(
                                                                          '${houses[index].zip.replaceAll(' ', '')} ${houses[index].city}\n',
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
                                                                  houses[index].bedrooms.toString()),
                                                              iconRowWidget(
                                                                  bathSVG,
                                                                  houses[index].bathrooms.toString()),
                                                              iconRowWidget(
                                                                  sizeSVG,
                                                                  houses[index].size.toString()),
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
                            ),
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
    );
  }

}
