import 'package:sage/src/Models/product.dart';

class CartItem {
  late int itemID;
  late int cartID;
  late int prodID;
  late int quantity;
  late int ordered;
  late double subtotal;
  late String pImage;
  late String pName;

  CartItem(
      {required this.itemID,
      required this.cartID,
      required this.prodID,
      required this.quantity,
      required this.subtotal,
      required this.ordered});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      itemID: int.parse(json['ItemID']),
      cartID: int.parse(json['CartID']),
      prodID: int.parse(json['ProdID']),
      quantity: int.parse(json['Quantity']),
      subtotal: double.parse(json['Subtotal']),
      ordered: int.parse(json['Ordered']),
    );
  }

  int get getID => itemID;
  int get getProdID => prodID;
  int get getCartID => cartID;
  int get getQuantity => quantity;
  int get getOrdered => ordered;
  double get getSubtotal => subtotal;
}
