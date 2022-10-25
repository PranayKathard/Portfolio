import 'package:sage/src/Models/product.dart';

class Order {

  int orderID;
  String products;
  int userId;
  double totalPrice;
  String address;
  int completed;
  List<Product> prods;

  Order({
    this.orderID,
    this.products,
    this.userId,
    this.totalPrice,//being total price.
    this.address,
    this.completed
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