import 'dart:developer';

class House{
  //Attributes
  late String id;
  late String image;
  late String price;
  late String bedrooms;
  late String bathrooms;
  late String size;
  late String description;
  late String zip;
  late String city;
  late String latitude;
  late String longitude;
  late String createdDate;

  //Constructor
  House({
    required this.id,
    required this.image,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.size,
    required this.description,
    required this.zip,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.createdDate});

  //JSON string handling
  factory House.fromJson(Map<String, dynamic> json) {
    return House(
      id: json['id'].toString(),
      image: json['image'].toString(),
      price: json['price'].toString(),
      bedrooms: json['bedrooms'].toString(),
      bathrooms: json['bathrooms'].toString(),
      size: json['size'].toString(),
      description: json['description'].toString(),
      zip: json['zip'].toString(),
      city: json['city'].toString(),
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
      createdDate: json['createdDate'].toString()
    );
  }
}