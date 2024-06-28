import 'package:sage/src/Models/product.dart';

class Order {

  late int orderID;
  late String products;
  late int userId;
  late double totalPrice;
  late String address;
  late int completed;
  late List<Product> prods;

  Order({
    required this.orderID,
    required this.products,
    required this.userId,
    required this.totalPrice,//being total price.
    required this.address,
    required this.completed
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderID: int.parse(json['ID']),
      products: json['products'],
      userId: int.parse(json['user_id']),
      totalPrice: double.parse(json['price']),
      address: json['address'],
      completed: int.parse(json['completed']),
    );
  }


  String generateInvoice(){
    String invoice="";

    return invoice;
  }
}