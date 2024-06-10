import 'dart:async';

import 'package:dtt_assessment/abstract.dart';
import 'package:dtt_assessment/floor_plan.dart';
import 'package:dtt_assessment/home_page.dart';
import 'package:dtt_assessment/service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:sizer/sizer.dart';

import 'house.dart';

class HouseDetail extends StatefulWidget {
  //Single house gets passed as parameter
  final House house;
  //Pass this through so we don't have to calculate again
  final double calculatedDistance;

  const HouseDetail({super.key, required this.house, required this.calculatedDistance});

  @override
  State<HouseDetail> createState() => _HouseDetailState();
}

class _HouseDetailState extends State<HouseDetail> {
  /*MAP*/
  GoogleMapController? mapController;
  final Completer<GoogleMapController> controller = Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    //Format the price
    String formattedPrice = NumberFormat.decimalPattern().format(int.parse(widget.house.price));
    //Centre map on pin
    LatLng center = LatLng(double.parse(widget.house.latitude), double.parse(widget.house.latitude));

    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                height: 30,
                width: 30,
                child: GestureDetector(
                  child: backSVG,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const HomePage();
                          },
                        ));
                  },
                ),
              ),
            ),
            expandedHeight: 200,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                rootImage + widget.house.image,
                fit: BoxFit.cover,
                width: double.maxFinite,
              ),
            ),
            //To give the white container curved edges at the top
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                child: Container(
                  color: const Color(0xffF7F7F7),
                  height: 20,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xffF7F7F7),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30,20,30,30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*** Price and metrics ***/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$$formattedPrice', style: title01,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            iconRowWidget(
                                bedSVG,
                                widget.house.bedrooms),
                            const SizedBox(width: 12,),
                            iconRowWidget(
                                bathSVG,
                                widget.house.bathrooms),
                            const SizedBox(width: 12,),
                            iconRowWidget(
                                sizeSVG,
                                widget.house.size),
                            const SizedBox(width: 12),
                            iconRowWidget(
                                locationSVG,
                                //If location denied (distance param = -1) then display '?' else display distance
                                (widget.calculatedDistance==-1)?'? km':'${widget.calculatedDistance.toStringAsFixed(1)} km'
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    /*Description and floor plan button*/
                    Row(
                      children: [
                        const Text('Description', style: title02,),
                        SizedBox(width: 5.w,),
                        SizedBox(
                          width: 100,
                          height: 25,
                          child: FloatingActionButton(onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (BuildContext context){
                                  return const FloorPlan();
                                })
                            );
                          },
                            backgroundColor: const Color(0xffEBEBEB),
                            child: const Text('FLOOR PLAN', style: subtitle,),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Text(widget.house.description, style: body,),
                    const SizedBox(height: 20,),
                    const Text('Location', style: title02,),
                    /*** Map ***/
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: SizedBox(
                          height: 30.h,
                          width: 95.w,
                          child: GoogleMap(
                            onMapCreated: controller.complete,
                            initialCameraPosition: CameraPosition(
                              target: center,
                              zoom: 10.0,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('SF'),
                                position: center,
                              ),
                            },
                            //Launch default map app when clicked
                            onTap: (centre) {
                              MapsLauncher.launchCoordinates(center.latitude, center.longitude);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]
      ),
    );
  }
}
