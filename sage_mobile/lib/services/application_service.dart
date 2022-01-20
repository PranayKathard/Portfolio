//import 'package:flutter_icons/flutter_icons.dart';
import 'package:sage_mobile/models/cart.dart';
import 'package:sage_mobile/models/cartItem.dart';
import 'package:sage_mobile/models/notification.dart';
import 'package:sage_mobile/models/order.dart';
import 'package:sage_mobile/models/product.dart';
import 'package:sage_mobile/models/quote.dart';
import 'package:sage_mobile/services/service.dart';
import 'package:sage_mobile/models/user.dart';

class ApplicationService {
  //static things
  static Cart cart = Cart.defaultCart;
  static User user = User.defaultUser;
  static int numNotifications = 0;
  static String address = "";

  //helper functions and methods

  //////////////////////////////////////////////////////////////////////////////
  //                                  USER                                    //
  //////////////////////////////////////////////////////////////////////////////
  static Future<User> getUser(String email) async {
    List<User> list = await Service.getUsers();
    User user = User.defaultUser;
    for (User u in list) {
      if (u.getEmail == email) {
        user = u;
      }
    }
    return user;
  }

  static emailValidator(String email) async {
    User user = await ApplicationService.getUser(email);
    if (user.getName != 'default') {
      return 1;
    } else {
      return 0;
    }
  }

  static void updateUserEmail(String newEmail) async {
    String response = await Service.updateUser(
        ApplicationService.user.email,
        newEmail,
        ApplicationService.user.name,
        ApplicationService.user.password);
    print(response);
  }

  static void updateUserPassword(String password) async {
    String response = await Service.updateUser(ApplicationService.user.email,
        ApplicationService.user.email, ApplicationService.user.name, password);
    print(response);
  }

  //////////////////////////////////////////////////////////////////////////////
  //                                 Quotes                                   //
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

  //////////////////////////////////////////////////////////////////////////////
  //                               Product                                    //
  //////////////////////////////////////////////////////////////////////////////
  static Future<List<Product>> fetchForSearch(String s) async {
    List<Product> prods = await Service.getProducts();
    List<Product> filtered = [];
    for (Product p in prods) {
      if (p.getName.toLowerCase().contains(s.toLowerCase())) {
        filtered.add(p);
      }
    }
    return filtered;
  }

  static Future<Product> getProduct(int prodID) async {
    List<Product> pList = await Service.getProducts();
    Product res = Product.defaultProd;
    for (Product p in pList) {
      if (p.getID == prodID) {
        res = p;
      }
    }
    return res;
  }

  static Future<List<Product>> fetchForCatalogue(
      String category, String price) async {
    List<Product> prods = await Service.getProducts();
    List<Product> filtered = [];
    if ((category == 'All') && (price == 'All')) {
      return prods;
    } else if ((category != 'All') && (price == 'All')) {
      for (Product p in prods) {
        if (p.category == category) {
          filtered.add(p);
        }
      }
    } else if ((category == 'All') && (price != 'All')) {
      if (price == '10000+') {
        price = '10000-0';
      }
      List<String> str = price.split('-');
      for (Product p in prods) {
        switch (str[0]) {
          case '0':
            if (isBetween(0, 999, p.price)) {
              filtered.add(p);
            }
            break;
          case '1000':
            if (isBetween(1000, 1999, p.price)) {
              filtered.add(p);
            }
            break;
          case '2000':
            if (isBetween(2000, 2999, p.price)) {
              filtered.add(p);
            }
            break;
          case '3000':
            if (isBetween(3000, 3999, p.price)) {
              filtered.add(p);
            }
            break;
          case '4000':
            if (isBetween(4000, 4999, p.price)) {
              filtered.add(p);
            }
            break;
          case '5000':
            if (isBetween(5000, 5999, p.price)) {
              filtered.add(p);
            }
            break;
          case '6000':
            if (isBetween(6000, 6999, p.price)) {
              filtered.add(p);
            }
            break;
          case '7000':
            if (isBetween(7000, 7999, p.price)) {
              filtered.add(p);
            }
            break;
          case '8000':
            if (isBetween(8000, 8999, p.price)) {
              filtered.add(p);
            }
            break;
          case '9000':
            if (isBetween(9000, 9999, p.price)) {
              filtered.add(p);
            }
            break;
          case '10000':
            if (p.price > 9999) {
              filtered.add(p);
            }
            break;
          default:
            return [];
        }
      }
    } else if ((category != 'All') && (price != 'All')) {
      List<Product> filtered2 = [];
      for (Product p in prods) {
        if (p.category == category) {
          filtered2.add(p);
        }
      }
      if (price == '10000+') {
        price = '10000-0';
      }
      List<String> str = price.split("-");
      for (Product p in filtered2) {
        switch (str[0]) {
          case '0':
            if (isBetween(0, 999, p.price)) {
              filtered.add(p);
            }
            break;
          case '1000':
            if (isBetween(1000.00, 1999.00, p.price)) {
              filtered.add(p);
            }
            break;
          case '2000':
            if (isBetween(2000, 2999, p.price)) {
              filtered.add(p);
            }
            break;
          case '3000':
            if (isBetween(3000, 3999, p.price)) {
              filtered.add(p);
            }
            break;
          case '4000':
            if (isBetween(4000, 4999, p.price)) {
              filtered.add(p);
            }
            break;
          case '5000':
            if (isBetween(5000, 5999, p.price)) {
              filtered.add(p);
            }
            break;
          case '6000':
            if (isBetween(6000, 6999, p.price)) {
              filtered.add(p);
            }
            break;
          case '7000':
            if (isBetween(7000, 7999, p.price)) {
              filtered.add(p);
            }
            break;
          case '8000':
            if (isBetween(8000, 8999, p.price)) {
              filtered.add(p);
            }
            break;
          case '9000':
            if (isBetween(9000, 9999, p.price)) {
              filtered.add(p);
            }
            break;
          case '10000':
            if (p.price > 9999) {
              filtered.add(p);
            }
            break;
          default:
            return [];
        }
      }
    }
    return filtered;
  }

  static bool isBetween(double from, double to, double price) {
    return from < price && price <= to;
  }

  //////////////////////////////////////////////////////////////////////////////
  //                                Cart                                      //
  //////////////////////////////////////////////////////////////////////////////
  static void addItemToCart(int cartID, int prodID, int quantity) async {
    double subtot = await calcSubtotal(prodID, quantity);
    if (itemExist(cartID, prodID)) {
      print('YES add');
      CartItem c = await getItem(cartID, prodID);
      c.quantity += 1;
      c.subtotal = await calcSubtotal(c.getProdID, c.quantity);
      Service.updateItem(c.getID, c.quantity, c.getSubtotal, 0);
    } else {
      Service.addItem(prodID, cartID, quantity, subtot, 0);
    }
  }

  static bool itemExist(int cartID, int prodID) {
    //List<CartItem> list = await getItems(cartID);
    bool bfound = false;
    for (CartItem c in ApplicationService.cart.items) {
      if (c.prodID == prodID) {
        bfound = true;
      }
    }
    return bfound;
  }

  static Future<double> calcSubtotal(int prodID, int quantity) async {
    Product prod = await getProduct(prodID);
    double subtot = prod.price * quantity;
    return subtot;
  }

  static Future<CartItem> getItem(int cart, int prod) async {
    CartItem result = CartItem.defaultCartItem;
    for (CartItem c in ApplicationService.cart.items) {
      if (c.prodID == prod) {
        result = c;
      }
    }
    return result;
  }

  static Future<List<CartItem>> getItems(int cartID) async {
    ApplicationService.cart.items = await Service.getItems(cartID);
    ApplicationService.cart.items.removeWhere((item) => item.ordered == 1);
    ApplicationService.cart.items.removeWhere((item) => item.quantity == 0);
    for (CartItem i in ApplicationService.cart.items) {
      Product p = await getProduct(i.prodID);
      i.pName = p.name;
      i.pImage = p.image;
    }
    return ApplicationService.cart.items;
  }

  static void calculateTotal() async {
    //List<CartItem> list = await getItems(Interface.cart.CartID);
    ApplicationService.cart.total = 0;
    for (CartItem c in ApplicationService.cart.items) {
      ApplicationService.cart.total += c.subtotal;
    }
    Service.updateCart(
        ApplicationService.cart.CartID, ApplicationService.cart.total);
    Cart c = await getCart(ApplicationService.user.getID);
    //Interface.cart.total = c.total;
  }

  static Future<Cart> getCart(int userID) async {
    List<Cart> carts = await Service.getAllCarts();
    Cart cart = Cart.defaultCart;
    for (Cart c in carts) {
      if (c.UserId == userID) {
        cart = c;
      }
    }
    return cart;
  }

  static void removeItemFromCart(int prodID, int cartID) async {
    if (itemExist(cartID, prodID)) {
      print('YES remove');
      CartItem c = await getItem(cartID, prodID);
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
  }

  static void clearCart() async {
    String prods = "";

    for (CartItem c in ApplicationService.cart.items) {
      prods += c.prodID.toString() + "," + c.quantity.toString() + ".";
      Product p = await getProduct(c.prodID);
      p.quantity -= c.quantity;
      await Service.updateProduct(p);
      c.ordered = 1;
      await Service.updateItem(c.itemID, c.quantity, c.subtotal, c.ordered);
    }
    createOrder(prods);
    ApplicationService.cart.items.clear();
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
        'A new quote was received from user ID:${ApplicationService.user.ID}, their email is ${ApplicationService.user.email}';
    List<User> managers = await ApplicationService.getManagers();
    for (User m in managers) {
      Service.addNotification(m.getID, 'New Quote Request', note);
    }
  }

  static void sendMangerOrderNote() async {
    String note =
        'A new ORDER was received from user ID:${ApplicationService.user.ID}, their email is ${ApplicationService.user.email}';
    List<User> managers = await ApplicationService.getManagers();
    for (User m in managers) {
      Service.addNotification(m.getID, 'New ORDER Received', note);
    }
  }

  static void updateNumNote() async {
    List<NotificationModel> list =
        await ApplicationService.getNotificationsForUser(
            ApplicationService.user.ID);
    ApplicationService.numNotifications = 0;
    ApplicationService.numNotifications = list.length;
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

  //////////////////////////////////////////////////////////////////////////////
  //                                Order                                     //
  //////////////////////////////////////////////////////////////////////////////
  static void createOrder(String prods) async {
    await Service.addOrder(prods, ApplicationService.user.ID,
        ApplicationService.cart.total, ApplicationService.address, 0);
    ApplicationService.cart.total = 0;
  }

  static Future<List<Order>> getOrdersForManager() async {
    List<Order> list = await Service.getOrders();
    list.removeWhere((item) => item.completed == 1);
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
    Order res = Order.defaultOrder;
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
}
