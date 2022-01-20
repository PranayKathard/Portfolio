import 'package:sage_mobile/models/product.dart';

class Order {
  int orderID = 0;
  String products = '';
  int userId = 0;
  double totalPrice = 0;
  String address = '';
  int completed = 0;
  List<Product> prods = [];
  static Order defaultOrder = Order(
      orderID: 0,
      products: '',
      userId: 0,
      totalPrice: 0,
      address: '',
      completed: 0);

  Order(
      {required this.orderID,
      required this.products,
      required this.userId,
      required this.totalPrice, //being total price.
      required this.address,
      required this.completed});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderID: int.parse(json['ID']),
      products: json['products'] as String,
      userId: int.parse(json['user_id']),
      totalPrice: double.parse(json['price']),
      address: json['address'] as String,
      completed: int.parse(json['completed']),
    );
  }

  String generateInvoice() {
    String invoice = "";

    return invoice;
  }
}
