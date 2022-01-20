import 'package:path_provider/path_provider.dart';
import 'package:sage/src/Models/product.dart';
import 'package:sage/src/Models/quote.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'src/Models/user.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  //User Table
  String userTable = 'users';
  String colName = 'name';
  String colEmail = 'email';
  String colPassword = 'password';
  String colUserType = 'user type';
  String colAddress = 'address';

  //Product Table
  String productTable = 'product';
  String colID_prod = 'ID';
  String colName_prod = 'name';
  String colDescription_prod = 'description';
  String colPrice_prod = 'price';
  String colImage_prod = 'image';
  String colQuantity_prod = 'quantity';
  String colCategory_prod = 'category';

  //Quotation Table
  String quotationTable = 'quote';
  String colID_quote = 'ID';
  String colDescription_quote = 'description';

  //Cart Table
  String cartTable = 'cart';
  String colItem_cart = 'items';

  //Order Table
  String orderTable = 'order';
  String colID_order = 'ID';
  String colItem_order = 'items';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory applicationDirectory = await getApplicationDocumentsDirectory();
    String path = applicationDirectory.path + 'sage.db';
    print('Path ' + path);
    final sageDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    return sageDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $quotationTable($colID_quote INTEGER PRIMARY KEY,$colDescription_quote TEXT)');
    await db.execute(
        'CREATE TABLE $userTable($colEmail TEXT PRIMARY KEY,$colName TEXT,$colPassword TEXT,$colUserType TEXT)');
    await db.execute(
        'CREATE TABLE $productTable($colID_prod INTEGER PRIMARY KEY AUTOINCREMENT,$colName_prod TEXT,$colCategory_prod TEXT,$colDescription_prod TEXT,$colPrice_prod DOUBLE,$colImage_prod TEXT,$colQuantity_prod INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getUser(String email) async {
    Database db = await this.database;
    var result = await db.query(userTable,
        columns: [colEmail, colPassword],
        where: '$colEmail = ?',
        whereArgs: [email]);
    return result;
  }

  Future<List<User>> getUserList(String email) async {
    List<User> l;
    Database db = await this.database;
    var result = await db.query(userTable,
        columns: [colEmail, colPassword],
        where: '$colEmail = ?',
        whereArgs: [email]);
    for (int i; i < result.length; i++) {
      User u = new User();
      u.fromMapToData(result[i]);
      l.add(u);
    }
    return l;
  }

  Future<User> getUserSingle(String email) async {
    User u = new User();
    Database db = await this.database;
    var result = await db.query(userTable,
        columns: [colEmail, colPassword],
        where: '$colEmail = ?',
        whereArgs: [email]);
    u.fromMapToData(result[0]);
    return u;
  }

  Future<int> putUser(User data) async {
    Database db = await this.database;
    int result = await db.insert(userTable, data.fromDataToMap());
    return result;
  }

  Future<List<Map<String, dynamic>>> getQuote(int id) async {
    Database db = await this.database;
    var result = await db.query(quotationTable,
        columns: [colDescription_quote],
        where: '$colID_quote = ?',
        whereArgs: [id]);
    return result;
  }

  Future<int> insertQuote(Quote q) async {
    Database db = await this.database;
    int result = await db.insert(quotationTable, q.fromDataToMap());
    return result;
  }

  Future<List<Map<String, dynamic>>> getProduct(int id) async {
    Database db = await this.database;
    var result = await db.query(productTable,
        columns: [
          colID_prod,
          colName_prod,
          colDescription_prod,
          colPrice_prod,
          colQuantity_prod,
          colImage_prod,
          colCategory_prod
        ],
        where: '$colID_prod = ?',
        whereArgs: [id]);
    return result;
  }

  Future<int> insertProduct(Product p) async {
    Database db = await this.database;
    int result = await db.insert(productTable, p.fromDataToMap());
    return result;
  }

  Future<int> deleteProduct(int id) async {
    Database db = await this.database;
    int result =
        await db.delete(productTable, where: 'ID = ?', whereArgs: [id]);
    return result;
  }

  Future<Product> getSingleProductName(int id) async {
    Product p = new Product();
    Database db = await this.database;
    var result = await db.query(productTable,
        columns: [colName_prod], where: '$colID_prod = ?', whereArgs: [id]);
    p.fromMapToData(result[0]);
    return p;
  }
}
