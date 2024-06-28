import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../object/house.dart';
import 'dart:math' as math;

//API

String rootAPI = 'https://intern.d-tt.nl/api/house';
//Image path is different to API path
String rootImage = 'https://intern.d-tt.nl/';
String apiKey = '98bww4ezuzfePCYFxJEWyszbUXc7dxRx';

//Get the list of houses
Future<List<House>> getHouses() async {
  try {
    //API get call
    final response = await http.get(Uri.parse(rootAPI), headers: {
      'Access-Key': apiKey
    },);
    //Success
    if (200 == response.statusCode) {
      //Parse JSON object to list of houses
      List<House> houses = parseResponse(response.body.toString());
      return houses;
    } else {
      //Return empty list if unsuccessful
      return [];
    }
  } on Error catch (e) {
    //For debugging purposes log error and return empty list
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

//Calculates how far away a house is from device location
double calculateDistanceAway(double lat1, double lon1, double? lat2, double? lon2) {
  // Radius of Earth in kilometers
  const double r = 6371;
  final double dLat = _toRadians(lat2! - lat1);
  final double dLon = _toRadians(lon2! - lon1);
  //Distance equation
  final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) *
          math.sin(dLon / 2) * math.sin(dLon / 2);
  final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return r * c;
}

//Generate radians for distance calculation
double _toRadians(double degree) {
  return degree * math.pi / 180;
}
