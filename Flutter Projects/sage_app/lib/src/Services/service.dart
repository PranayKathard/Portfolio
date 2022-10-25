import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sage/interface.dart';
import 'package:sage/src/Models/cart.dart';
import 'package:sage/src/Models/cartItem.dart';
import 'package:sage/src/Models/order.dart';
import 'package:sage/src/Models/notification.dart';
import 'package:sage/src/Models/product.dart';
import 'package:sage/src/Models/quote.dart';
import 'package:sage/src/Models/user.dart';
import 'package:sage/src/Services/application_service.dart';

class Service {
  static const ROOT = "https://sagestoredatabase.000webhostapp.com/data.php";

  // User table constants
  static const ADDUSERACTION = "ADD_USER";
  static const DELETEUSERACTION = "DELETE_USER";
  static const UPDATEUSERACTION = "UPDATE_USER";
  static const GETUSERACTION = "GET_ALL_USERS";

  // product table constants
  static const ADDPRODACTION = "ADD_PRODUCT";
  static const DELETEPRODACTION = "DELETE_PRODUCT";
  static const UPDATEPRODACTION = "UPDATE_PRODUCT";
  static const GETPRODACTION = "GET_ALL_PRODUCTS";
  static const GETCATPRODACTION = "GET_ALL_PRODUCTS_CATEGORY";

  //Quote table constants
  static const ADDQUOTEACTION = "ADD_QUOTE";
  static const DELETEQUOTEACTION = "DELETE_QUOTE";
  static const UPDATEQUOTEACTION = "UPDATE_PRODUCT";
  static const GETQUOTEACTION = "GET_ALL_QUOTES";

  //////////////////////////////////////////////////////////////////////////////
  //User database interactions
  //////////////////////////////////////////////////////////////////////////////
  static Future<List<User>> getUsers() async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map["action"] = GETUSERACTION;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Get Users Response: ${response.body}');
      if (200 == response.statusCode) {
        List<User> list = parseResponse(response.body.toString());
        return list;
      } else {
        return List<User>();
      }
    } on Error catch (e) {
      print('Error: $e');
      return List<User>();
    }
  }

  static Future<String> addUser(
      String email, String name, String password, String userType) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['action'] = ADDUSERACTION;
      map['name'] = name;
      map['email'] = email;
      map['password'] = password;
      map['user_type'] = userType;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Add Quote Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error user cant be added";
      }
    } catch (e) {
      return "error adding users";
    }
  }

  static Future<String> updateUser(
      String email, String newEmail, String name, String password) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['action'] = UPDATEUSERACTION;
      map['name'] = name.toString();
      map['email'] = email.toString();
      map['newEmail'] = newEmail.toString();
      map['password'] = password.toString();
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Update Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error user cant be updated";
      }
    } catch (e) {
      return "error update users";
    }
  }

  static Future<String> deleteUser(String email) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['action'] = DELETEUSERACTION;
      map['email'] = email;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Delete user Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error user cant be deleted";
      }
    } catch (e) {
      return "error delete users";
    }
  }

  static List<User> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  //////////////////////////////////////////////////////////////////////////////
  //Blocked User database interactions
  //////////////////////////////////////////////////////////////////////////////
  static Future<List<User>> getBlocked() async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map["action"] = "GET_ALL_BLOCKED";
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Get Blocked Response: ${response.body}');
      if (200 == response.statusCode) {
        List<User> list = parseBlockedResponse(response.body.toString());
        return list;
      } else {
        return [];
      }
    } on Error catch (e) {
      print('Error: $e');
      return [];
    }
  }

  static Future<String> addBlocked(
      String email, String name, String password, String userType) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['action'] = "ADD_BLOCKED";
      map['name'] = name.toString();
      map['email'] = email.toString();
      map['password'] = password.toString();
      map['user_type'] = userType.toString();
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Add Blocked Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error blocked user cant be added";
      }
    } catch (e) {
      return "error adding blocked user";
    }
  }

  static Future<String> deleteBlocked(String email) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['action'] = "DELETE_BLOCKED";
      map['email'] = email;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Delete blocked user Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error blocked user cant be deleted";
      }
    } catch (e) {
      return "error delete blocked user";
    }
  }

  static List<User> parseBlockedResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  //////////////////////////////////////////////////////////////////////////////
  //Product database interactions
  //////////////////////////////////////////////////////////////////////////////
  static Future<List<Product>> getProducts() async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map["action"] = GETPRODACTION;
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print('Get Product Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Product> list = parseProdResponse(response.body.toString());
        return list;
      } else {
        return List<Product>();
      }
    } on Error catch (e) {
      print('Error: $e');
      return List<Product>();
    }
  }

  static Future<List<Product>> getCategoryProducts(String category) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map["action"] = GETCATPRODACTION;
      map["category"] = category;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Get Product by Category Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Product> list = parseProdResponse(response.body.toString());
        return list;
      } else {
        return List<Product>();
      }
    } on Error catch (e) {
      print('Error: $e');
      return List<Product>();
    }
  }

  static Future<String> addProduct(
      String name,
      String description,
      double price,
      String image,
      int quantity,
      String category,
      double discount,
      String specs) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['action'] = ADDPRODACTION;
      map['name'] = name;
      map['description'] = description;
      map['price'] = price.toString();
      map['image'] = image.toString();
      map['quantity'] = quantity.toString();
      map['category'] = category;
      map['discount'] = discount.toString();
      map['specs'] = specs;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Add Product Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body.toString();
      } else {
        return "error user cant be added";
      }
    } catch (e) {
      print(e);
      return "error adding users";
    }
  }

  static Future<String> updateProduct(Product p) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['action'] = UPDATEPRODACTION;
      map['ID'] = p.ID.toString();
      map['name'] = p.name.toString();
      map['description'] = p.description.toString();
      map['price'] = p.price.toString();
      map['image'] = p.image.toString();
      map['quantity'] = p.quantity.toString();
      map['category'] = p.category.toString();
      map['discount'] = p.discount.toString();
      map['specs'] = p.specs.toString();
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Product update Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error user cant be updated";
      }
    } catch (e) {
      return "error update users";
    }
  }

  static Future<String> deleteProduct(int id) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['action'] = DELETEPRODACTION;
      map['ID'] = id.toString();
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Delete Product Response: ${response.body}');
      if (200 == response.statusCode) {
        //List<User> list = parseResponse(response.body);
        return response.body;
      } else {
        return "error user cant be deleted";
      }
    } catch (e) {
      print(e);
      return "error delete users";
    }
  }

  static List<Product> parseProdResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  }

  //////////////////////////////////////////////////////////////////////////////

  //Quote database interactions
  //////////////////////////////////////////////////////////////////////////////
  static Future<List<Quote>> getQuotes() async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map["action"] = GETQUOTEACTION;
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print('Get Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Quote> list = parseQuoteResponse(response.body.toString());
        return list.reversed.toList();
      } else {
        return [];
      }
    } on Error catch (e) {
      print('Error: $e');
      return [];
    }
  }

  static Future<String> addQuote(String description, int userID) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['action'] = ADDQUOTEACTION;
      map['description'] = description;
      map['user_id'] = userID.toString();
      print(map);
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Add Quote Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        print('e1');
        return "error user cant be added";
      }
    } catch (e) {
      print(e);
      return "error adding users";
    }
  }

  static Future<String> deleteQuote(int id) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['action'] = DELETEQUOTEACTION;
      map['ID'] = id;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Delete user Response: ${response.body}');
      if (200 == response.statusCode) {
        //List<User> list = parseResponse(response.body);
        return response.body;
      } else {
        return "error user cant be deleted";
      }
    } catch (e) {
      return "error delete users";
    }
  }

  static List<Quote> parseQuoteResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Quote>((json) => Quote.fromJson(json)).toList();
  }

  //////////////////////////////////////////////////////////////////////////////

//Cart database interactions
//////////////////////////////////////////////////////////////////////////////
  static Future<List<Cart>> getCart(int userID) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map["action"] = "GET_CART";
      map['UserID'] = userID.toString();
      final response = await http.post(Uri.parse(ROOT), body: map);
      // print('Get Cart Response: ${response.body}');
      if (200 == response.statusCode) {
        print('here');
        List<Cart> carts = parseCartResponse(response.body.toString());
        print('after');
        return carts;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Cart>> getAllCarts() async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map["action"] = "GET_ALL_CARTS";
      final response = await http.post(Uri.parse(ROOT), body: map);
      //print('Get Cart Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Cart> carts = parseCartResponse(response.body.toString());
        return carts;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String> addCart(int userId, double total) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['action'] = "ADD_CART";
      map['UserID'] = userId.toString();
      map['Total'] = total.toString();
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('add cart Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error cart cant be added";
      }
    } catch (e) {
      return "error add cart";
    }
  }

  static Future<String> updateCart(int id, double total) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['action'] = "UPDATE_CART";
      map['CartID'] = id.toString();
      map['Total'] = total.toString();
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('update cart Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error cart cant be updated";
      }
    } catch (e) {
      return "error delete cart";
    }
  }

  static Future<String> deleteCart(int cartId) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['action'] = "DELETE_CART";
      map['CartID'] = cartId.toString();
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Delete cart Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error cart cant be deleted";
      }
    } catch (e) {
      return "error delete cart";
    }
  }

  static List<Cart> parseCartResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Cart>((json) => Cart.fromJson(json)).toList();
  }

//////////////////////////////////////////////////////////////////////////////

//CartItem database interactions
//////////////////////////////////////////////////////////////////////////////
  static Future<List<CartItem>> getItems(int cartID) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map["action"] = "GET_ITEMS";
      map["CartID"] = cartID.toString();
      final response = await http.post(Uri.parse(ROOT), body: map);
      //print('Get CartItems Response: ${response.body}');
      if (200 == response.statusCode) {
        List<CartItem> list;
        if (!response.body.toString().contains("error")) {
          list = parseItemResponse(response.body.toString());
        }
        //print(list);
        if (list == null) {
          print('null list');
        }
        //print(list[0].getID);
        return list;
      } else {
        return List<CartItem>();
      }
    } on Error catch (e) {
      print('this 1');
      print('Error: $e');
      return List<CartItem>();
    }
  }

  static Future<String> updateItem(
      int itemID, int quantity, double subtotal, int ordered) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['action'] = "UPDATE_ITEM";
      map['ItemID'] = itemID.toString();
      map['Quantity'] = quantity.toString();
      map['Ordered'] = ordered.toString();
      map['Subtotal'] = subtotal.toString();
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('update Item Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error item cant be updated";
      }
    } catch (e) {
      return "error update item";
    }
  }

  static Future<String> addItem(int prodId, int cartId, int quantity,
      double subtotal, int ordered) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['action'] = "ADD_ITEM";
      map['CartID'] = cartId.toString();
      map['ProdID'] = prodId.toString();
      map['Ordered'] = ordered.toString();
      map['Quantity'] = quantity.toString();
      map['Subtotal'] = subtotal.toString();
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Add CartItem Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error item cant be added";
      }
    } catch (e) {
      return "error add item";
    }
  }

  static Future<String> deleteItem(int itemId) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['action'] = "DELETE_ITEM";
      map['ItemID'] = itemId.toString();
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Delete Item Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error Item cant be deleted";
      }
    } catch (e) {
      print(e);
      return "error delete Item";
    }
  }

  static List<CartItem> parseItemResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<CartItem>((json) => CartItem.fromJson(json)).toList();
  }

//////////////////////////////////////////////////////////////////////////////
//order table
//////////////////////////////////////////////////////////////////////////////
  static Future<List<Order>> getOrders() async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map["action"] = "GET_ORDERS";
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Get Orders Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Order> list;
        if (!response.body.toString().contains("error")) {
          list = parseOrderResponse(response.body.toString());
        }
        return list.reversed.toList();
      } else {
        print('error list');
        return [];
      }
    } on Error catch (e) {
      print('Error: $e');
      return [];
    }
  }

  static Future<String> addOrder(String products, int userId, double totalPrice,
      String address, int completed) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['action'] = "ADD_ORDER";
      map['products'] = products;
      map['user_id'] = userId.toString();
      map['price'] = totalPrice.toString();
      map['address'] = address;
      map['completed'] = completed.toString();
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Add Order Response: ${response.body}');
      //print('code '+response.statusCode.toString());
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error Order cant be added";
      }
    } catch (e) {
      return "error order add";
    }
  }

  static Future<String> updateOrder(int id, String products, int userId,
      double totalPrice, String address, int completed) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['action'] = "UPDATE_ORDER";
      map['ID'] = id.toString();
      map['products'] = products.toString();
      map['user_id'] = userId.toString();
      map['price'] = totalPrice.toString();
      map['address'] = address.toString();
      map['completed'] = completed.toString();
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('update order Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error order cant be updated";
      }
    } catch (e) {
      return "error update order";
    }
  }

  static List<Order> parseOrderResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Order>((json) => Order.fromJson(json)).toList();
  }

//////////////////////////////////////////////////////////////////////////////

//Notification database interactions
//////////////////////////////////////////////////////////////////////////////
  static Future<List<NotificationModel>> getNotifications() async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map["action"] = "GET_ALL_NOTIFICATIONS";
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Get Notifications Response: ${response.body}');
      if (200 == response.statusCode) {
        List<NotificationModel> list =
            parseNotificationResponse(response.body.toString());
        return list.reversed.toList();
      } else {
        return [];
      }
    } on Error catch (e) {
      print('Error: $e');
      return [];
    }
  }

  static Future<String> deleteNotification(int id) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['action'] = 'DELETE_NOTIFICATION';
      map['id'] = id.toString();
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Delete Notification Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error user cant be deleted";
      }
    } catch (e) {
      return "error delete users";
    }
  }

  static Future<String> addNotification(
      int user_id, String header, String note) async {
    try {
      //parameters to pass request
      var map = Map<String, dynamic>();
      map['action'] = "ADD_NOTIFICATION";
      map['user_id'] = user_id.toString();
      map['header'] = header.toString();
      map['note'] = note.toString();
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('id: $user_id header: $header note:$note');
      print('Add Notification Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error notification cant be added";
      }
    } catch (e) {
      return "error add notification";
    }
  }

  static List<NotificationModel> parseNotificationResponse(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<NotificationModel>((json) => NotificationModel.fromJson(json))
        .toList();
  }
}
