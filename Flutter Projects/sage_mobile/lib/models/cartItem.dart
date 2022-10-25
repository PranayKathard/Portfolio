import 'package:sage_mobile/models/product.dart';

class CartItem {
  int itemID;
  int cartID;
  int prodID;
  int quantity;
  int ordered;
  double subtotal;
  String pImage = '';
  String pName = '';
  static CartItem defaultCartItem = CartItem(
      itemID: 0, cartID: 0, prodID: 0, quantity: 0, subtotal: 0, ordered: 0);

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
