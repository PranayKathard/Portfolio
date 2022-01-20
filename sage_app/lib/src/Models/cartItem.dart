import 'package:sage/src/Models/product.dart';

class CartItem {
  int itemID;
  int cartID;
  int prodID;
  int quantity;
  int ordered;
  double subtotal;
  String pImage;
  String pName;

  CartItem(
      {this.itemID,
      this.cartID,
      this.prodID,
      this.quantity,
      this.subtotal,
      this.ordered});

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
