import 'package:sage/src/Models/cartItem.dart';

class Cart {
  int CartID = 0;
  int UserId = 0;
  double total = 0;
  List<CartItem> items;

  Cart({
    this.CartID,
    this.UserId,
    this.total, //being total price.
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      CartID: int.parse(json['CartID']),
      UserId: int.parse(json['UserID']),
      total: double.parse(json['Total']),
    );
  }

  double get getTotal => total;
}
