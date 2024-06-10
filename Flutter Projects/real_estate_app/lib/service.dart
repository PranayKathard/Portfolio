import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'house.dart';
import 'dart:math' as math;

//API

String rootAPI = 'https://intern.d-tt.nl/api/house';
String rootImage = 'https://intern.d-tt.nl/';
String apiKey = '98bww4ezuzfePCYFxJEWyszbUXc7dxRx';

//Get the list of houses
Future<List<House>> getHouses() async {
  try {
    final response = await http.get(Uri.parse(rootAPI), headers: {
      'Access-Key': apiKey
    },);
    if (200 == response.statusCode) {
      List<House> houses = parseResponse(response.body.toString());
      return houses;
    } else {
      log(response.statusCode.toString());
      return [];
    }
  } on Error catch (e) {
    log('Error: $e');
    return [];
  }
}

//Parse json body to list of houses
List<House> parseResponse(String responseBody) {
final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
return parsed.map<House>((json) => House.fromJson(json)).toList();
}

//LOCATION

//Calculates how far away a house is
double calculateDistanceAway(double lat1, double lon1, double? lat2, double? lon2) {
  const double r = 6371; // Radius of Earth in kilometers
  final double dLat = _toRadians(lat2! - lat1);
  final double dLon = _toRadians(lon2! - lon1);
  final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) *
          math.sin(dLon / 2) * math.sin(dLon / 2);
  final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return r * c;
}

double _toRadians(double degree) {
  return degree * math.pi / 180;
}

//SEARCH

//Search using City or Postal code
Future<List<House>> searchHouses(String searchTerm) async {
  List<House> houses = await getHouses();
  List<House> filtered = [];
  for (House h in houses) {
    if ((h.zip.toLowerCase().contains(searchTerm.toLowerCase())) || (h.city.toLowerCase().contains(searchTerm.toLowerCase()))) {
    filtered.add(h);
    }
  }
  if(searchTerm == ''){
    return houses;
  }else {
    return filtered;
  }
}

//FILTER

Future<List<House>> filterPrice(int sortPrice,double bedSlider, double bathSlider) async {
  List<House> houses = await getHouses();

  //Price
  if(sortPrice == 0){
    //Price lowest to highest
    houses.sort((a, b) => double.parse(a.price).compareTo(double.parse(b.price)));
  }
  else if(sortPrice == 1){
    //Price highest to lowest
    houses.sort((a, b) => double.parse(a.price).compareTo(double.parse(b.price)));
    houses = houses.reversed.toList();
  }

  //Beds and baths
  houses.removeWhere((h) => double.parse(h.bedrooms) < bedSlider);
  houses.removeWhere((h) => double.parse(h.bathrooms) < bathSlider);

 return houses;
}
