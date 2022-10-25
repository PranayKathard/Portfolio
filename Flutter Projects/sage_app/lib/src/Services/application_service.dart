import 'package:sage/src/Models/cart.dart';
import 'package:sage/src/Models/cartItem.dart';
import 'package:sage/src/Models/order.dart';
import 'package:sage/src/Models/quote.dart';
import '../../interface.dart';
import 'service.dart';
import 'package:sage/src/Models/user.dart';
import 'package:sage/src/Models/product.dart';
import 'package:sage/src/Models/notification.dart';

class ApplicationService {
  //////////////////////////////////////////////////////////////////////////////
  //                                USER                                      //
  //////////////////////////////////////////////////////////////////////////////
  static Future<User> getUser(String email) async {
    List<User> list = await Service.getUsers();
    User user;
    for (User u in list) {
      if (u.getEmail == email) {
        user = u;
      }
    }
    return user;
  }

  static Future<List<User>> getManagers() async {
    List<User> list = await Service.getUsers();
    List<User> managers = [];
    for (User u in list) {
      if (u.userType == 'manager') {
        managers.add(u);
      }
    }
    return managers;
  }

  static void updateUserEmail(String newEmail) async {
    String response = await Service.updateUser(Interface.user.email, newEmail,
        Interface.user.name, Interface.user.password);
    print(response);
  }

  static void updateUserPassword(String password) async {
    String response = await Service.updateUser(Interface.user.email,
        Interface.user.email, Interface.user.name, password);
    print(response);
  }

  //////////////////////////////////////////////////////////////////////////////
  //                                PRODUCTS                                  //
  //////////////////////////////////////////////////////////////////////////////
  static Future<List<Product>> fetchForDelete(String s) async {
    List<Product> prods = await Service.getProducts();
    List<Product> filtered = [];
    for (Product p in prods) {
      if (p.getName.toLowerCase().contains(s.toLowerCase())) {
        filtered.add(p);
      }
    }
    return filtered;
  }

  static Future<List<Product>> getProdQuantity20() async {
    List<Product> list = await Service.getProducts();
    for (Product p in list) {
      if (p.quantity > 20) {
        list.remove(p);
      }
    }
    return list;
  }

  static Future<List<Product>> getSoldOut() async {
    List<Product> list = await Service.getProducts();
    List<Product> soldOut = [];
    for (Product p in list) {
      if (p.quantity == 0) {
        soldOut.add(p);
      }
    }
    return soldOut;
  }

  static Future<List<Product>> getSpecials() async {
    List<Product> list = await Service.getProducts();
    list.removeWhere((item) => item.getDiscount == 0);
    return list;
  }

  static Future<Product> getProduct(int prodID) async {
    List<Product> pList = await Service.getProducts();
    Product res;
    for (Product p in pList) {
      if (p.getID == prodID) {
        res = p;
      }
    }
    return res;
  }

  static Future<List<Product>> getProdsForQuote(
      List<String> specs, String category) async {
    List<Product> pList = await Service.getCategoryProducts(category);
    List<Product> removeList = [];
    for (Product p in pList) {
      print(p.getName);
      List<String> specs2 = p.specs.split(',');
      print(specs);
      print(specs2);
      for (int i = 0; i < 12; i++) {
        if ((specs2[i] != specs[i]) && (specs[i] != 'any')) {
          if (!removeList.contains(p)) {
            removeList.add(p);
          }
          print("REMOVED: " + p.getName);
        }
      }
    }
    for (Product p in removeList) {
      pList.remove(p);
    }
    return pList;
  }

  static void setSpecial(Product prod) async {
    double minusAmount = (prod.discount / 100) * prod.price;
    prod.price = prod.price - minusAmount;
    String s = await Service.updateProduct(prod);
    print(s);
  }

  //////////////////////////////////////////////////////////////////////////////
  //                                CART                                      //
  //////////////////////////////////////////////////////////////////////////////
  static Future<Cart> getCart(int userID) async {
    List<Cart> carts = await Service.getAllCarts();
    Cart cart;
    for (Cart c in carts) {
      if (c.UserId == userID) {
        cart = c;
      }
    }
    return cart;
  }

  static Future<List<CartItem>> getItems(int cartID) async {
    //List<CartItem> items = await Service.getItems(cartID);
    Interface.cart.items = await Service.getItems(cartID);
    if (Interface.cart.items != null) {
      Interface.cart.items.removeWhere((item) => item.ordered == 1);
      Interface.cart.items.removeWhere((item) => item.quantity == 0);
      for (CartItem i in Interface.cart.items) {
        Product p = await getProduct(i.prodID);
        i.pName = p.name;
        i.pImage = p.image;
      }
    }
    return Interface.cart.items;
  }

  static void addItemToCart(int cartID, int prodID, int quantity) async {
    if (itemExist(cartID, prodID)) {
      CartItem c = getItem(cartID, prodID);
      //print(c.quantity);
      c.quantity += quantity;
      //print(c.quantity);
      c.subtotal = await calcSubtotal(c.prodID, c.quantity);
      Service.updateItem(c.itemID, c.quantity, c.subtotal, 0);
    } else {
      double subtot = await calcSubtotal(prodID, quantity);
      Service.addItem(prodID, cartID, quantity, subtot, 0);
    }
    //calculateTotal();
  }

  static void removeItemFromCart(int prodID, int cartID) async {
    if (itemExist(cartID, prodID)) {
      CartItem c = getItem(cartID, prodID);
      //print(c.quantity);
      c.quantity -= 1;
      //print(c.quantity);
      if (c.quantity > 0) {
        c.subtotal = await calcSubtotal(c.prodID, c.quantity);
        Service.updateItem(c.itemID, c.quantity, c.subtotal, 0);
      } else if (c.quantity == 0) {
        Service.deleteItem(c.itemID);
      }
    }
    //calculateTotal();
  }

  static bool itemExist(int cartID, int prodID) {
    //List<CartItem> list = await getItems(cartID);
    bool bfound = false;
    if (Interface.cart.items != null) {
      for (CartItem c in Interface.cart.items) {
        if (c.prodID == prodID) {
          bfound = true;
        }
      }
    }
    return bfound;
  }

  static Future<double> calcSubtotal(int prodID, int quantity) async {
    Product prod = await getProduct(prodID);
    double subtot = prod.price * quantity;
    return subtot;
  }

  static void calculateTotal() async {
    //List<CartItem> list = await getItems(Interface.cart.CartID);
    Interface.cart.total = 0;
    if (Interface.cart.items != null) {
      for (CartItem c in Interface.cart.items) {
        Interface.cart.total += c.subtotal;
      }
      Service.updateCart(Interface.cart.CartID, Interface.cart.total);
    }
  }

  static CartItem getItem(int cart, int prod) {
    // List<CartItem> list = await getItems(cart);
    CartItem result;
    for (CartItem c in Interface.cart.items) {
      if (c.prodID == prod) {
        result = c;
      }
    }
    return result;
  }

  static void clearCart() async {
    String prods = "";

    for (CartItem c in Interface.cart.items) {
      prods += c.prodID.toString() + "," + c.quantity.toString() + ".";
      Product p = await getProduct(c.prodID);
      p.quantity -= c.quantity;
      await Service.updateProduct(p);
      c.ordered = 1;
      await Service.updateItem(c.itemID, c.quantity, c.subtotal, c.ordered);
    }
    createOrder(prods);
    Interface.cart.items.clear();
  }

  //////////////////////////////////////////////////////////////////////////////
  //                                QUOTE                                     //
  //////////////////////////////////////////////////////////////////////////////
  static Future<List<Quote>> fetchQuotes(String s) async {
    List<Quote> prods = await Service.getQuotes();
    List<Quote> filtered = [];
    for (Quote p in prods) {
      if (p.getID == int.parse(s)) {
        filtered.add(p);
      }
    }
    return filtered;
  }

  static Future<List<int>> getQuantityForQuotePie() async {
    List<Quote> prods = await Service.getQuotes();
    List<int> amounts = [0, 0, 0, 0, 0];
    for (Quote q in prods) {
      List<String> s = q.description.split(';');
      switch (s[1]) {
        case ('bags'):
          amounts[0] += 1;
          break;
        case ('laptops'):
          amounts[1] += 1;
          break;
        case ('storage devices'):
          amounts[2] += 1;
          break;
        case ('printer'):
          amounts[3] += 1;
          break;
        case ('other'):
          amounts[4] += 1;
          break;
      }
    }
    return amounts;
  }

  //////////////////////////////////////////////////////////////////////////////
  //                                Order                                     //
  //////////////////////////////////////////////////////////////////////////////
  static void createOrder(String prods) async {
    await Service.addOrder(
        prods, Interface.user.ID, Interface.cart.total, Interface.address, 0);
    Interface.cart.total = 0;
  }

  static Future<List<Order>> fetchOrders(String s) async {
    List<Order> ords = await Service.getOrders();
    List<Order> filtered = [];
    for (Order p in ords) {
      if (p.orderID == int.parse(s)) {
        filtered.add(p);
      }
    }
    for (Order o in filtered) {
      List<String> strProd = o.products.split(".");
      strProd.removeWhere((element) => element == "");
      Product product;
      o.prods = [];
      for (String p in strProd) {
        List<String> pList = p.split(",");
        int id = int.parse(pList[0]);
        product = await getProduct(id);
        int quant = int.parse(pList[1]);
        product.quantity = quant;
        o.prods.add(product);
      }
    }
    return filtered;
  }

  static Future<List<Order>> getOrdersForManager() async {
    List<Order> list = await Service.getOrders();
    for (Order o in list) {
      List<String> strProd = o.products.split(".");
      strProd.removeWhere((element) => element == "");
      Product product;
      o.prods = [];
      for (String p in strProd) {
        List<String> pList = p.split(",");
        int id = int.parse(pList[0]);
        product = await getProduct(id);
        int quant = int.parse(pList[1]);
        product.quantity = quant;
        o.prods.add(product);
      }
    }
    return list;
  }

  static Future<List<Order>> getOrdersUser(int userID) async {
    List<Order> list = await Service.getOrders();
    list.removeWhere((element) => element.userId != userID);
    for (Order o in list) {
      List<String> strProd = o.products.split(".");
      strProd.removeWhere((element) => element == "");
      Product product;
      o.prods = [];
      for (String p in strProd) {
        List<String> pList = p.split(",");
        int id = int.parse(pList[0]);
        product = await getProduct(id);
        int quant = int.parse(pList[1]);
        product.quantity = quant;
        o.prods.add(product);
      }
    }
    return list;
  }

  static Future<Order> getOrder(int orderID) async {
    List<Order> orders = await Service.getOrders();
    Order res;
    for (Order o in orders) {
      if (o.orderID == orderID) {
        res = o;
      }
    }
    return res;
  }

  static String getOrderItems(Order order) {
    String orderItems = "";
    for (Product p in order.prods) {
      orderItems += p.name + ",";
    }
    return orderItems;
  }

  static String getOrderItemQuantities(Order order) {
    String orderItems = "";
    for (Product p in order.prods) {
      orderItems += p.quantity.toString() + ",";
    }
    return orderItems;
  }

  static String getOrderItemPrices(Order order) {
    String orderItems = "";
    for (Product p in order.prods) {
      orderItems += (p.price * p.quantity).toStringAsFixed(2) + ",";
    }
    return orderItems;
  }

  static void completeOrder(Order o) async {
    await Service.updateOrder(
        o.orderID, o.products, o.userId, o.totalPrice, o.address, 1);
  }

  //////////////////////////////////////////////////////////////////////////////
  //                            NOTIFICATION                                  //
  //////////////////////////////////////////////////////////////////////////////

  static Future<List<NotificationModel>> getNotificationsForUser(
      int user_id) async {
    List<NotificationModel> list = await Service.getNotifications();
    List<NotificationModel> list2 = [];
    for (NotificationModel n in list) {
      if (n.user_id == user_id) {
        list2.add(n);
      }
    }
    return list2;
  }

  static void sendMangerQuoteNote() async {
    String note =
        'A new QUOTE was received from user ID:${Interface.user.ID}, their email is ${Interface.user.email}';
    List<User> managers = await ApplicationService.getManagers();
    for (User m in managers) {
      Service.addNotification(m.getID, 'New QUOTE Request', note);
    }
  }

  static void sendMangerOrderNote() async {
    String note =
        'A new ORDER was received from user ID:${Interface.user.ID}, their email is ${Interface.user.email}';
    List<User> managers = await ApplicationService.getManagers();
    for (User m in managers) {
      Service.addNotification(m.getID, 'New ORDER Received', note);
    }
  }

  static void updateNumNote() async {
    Interface.numNotifications = 0;
    List<NotificationModel> list =
        await ApplicationService.getNotificationsForUser(Interface.user.ID);
    Interface.numNotifications = list.length;
  }
}
