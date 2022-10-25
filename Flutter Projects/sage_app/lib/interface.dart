import 'package:sage/src/Models/cart.dart';
import 'package:sage/src/Models/quote.dart';
import 'package:sage/src/Services/application_service.dart';

import 'database_helper.dart';
import 'src/Models/user.dart';

class Interface {
  DatabaseHelper helper = DatabaseHelper();
  static User user = User();
  static Cart cart = Cart();
  static String address = "";
  static int numNotifications = 0;

  addUser(String email, String name, String password) async {
    User data = User();
    int result = await this.helper.putUser(data);
    return result;
  }

  emailValidator(String email) async {
    User user = await ApplicationService.getUser(email);
    if (user != null) {
      return 1;
    } else {
      return 0;
    }
  }

  passwordValidator(String email, String password) async {
    List<Map<String, dynamic>> list = await this.helper.getUser(email);
    if (list[0]['password'] == password) {
      return 1;
    } else {
      return 0;
    }
  }

  addQuote(String description) async {
    Quote.quotes += 1;
    Quote q = Quote();
    int result = await this.helper.insertQuote(q);
    print('Added quote');
    return result;
  }
}
