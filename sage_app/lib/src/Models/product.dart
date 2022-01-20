class Product {
  int ID = 0;
  String name = '';
  String description = '';
  double price = 0.0;
  String image = '';
  int quantity = 0;
  String category = '';
  double discount = 0;
  /*
  [0] = size screen/bag
  [1] = bag brand
  [2] = bag color
  [3] = laptop processor
  [4] = laptop memory
  [5] = laptop HDD
  [6] = laptop LTE
  [7] = laptop graphics
  [8] = storage size
  [9] = printer brand
  [10] = printer type
  [11] = other type
   */
  String specs = '';

  Product(
      {this.ID,
      this.name,
      this.description,
      this.price,
      this.image,
      this.quantity,
      this.category,
      this.discount,
      this.specs});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        ID: int.parse(json['ID']),
        name: json['name'] as String,
        description: json['description'] as String,
        price: double.parse(json['price']),
        image: json['image'] as String,
        quantity: int.parse(json['quantity']),
        category: json['category'] as String,
        discount: double.parse(json['discount']),
        specs: json['specs'] as String);
  }

  int get getID => ID;
  String get getName => name;
  String get getDescription => description;
  double get getPrice => price;
  String get getImage => image;
  int get getQuantity => quantity;
  String get getCategory => category;
  double get getDiscount => discount;

  set setDescription(String value) {
    this.description = value;
  }

  set setName(String name) {
    this.name = name;
  }

  set setPrice(double value) {
    this.price = value;
  }

  set setImage(String value) {
    this.image = value;
  }

  set setQuantity(int value) {
    this.quantity = value;
  }

  set setCategory(String value) {
    this.category = value;
  }

  set setDiscount(double value) {
    this.discount = value;
  }

  Map<String, dynamic> fromDataToMap() {
    var map = Map<String, dynamic>();
    map['ID'] = this.ID;
    map['name'] = this.name;
    map['description'] = this.description;
    map['price'] = this.price;
    map['image'] = this.image;
    map['quantity'] = this.quantity;
    map['category'] = this.category;
    return map;
  }

  fromMapToData(Map<String, dynamic> map) {
    this.ID = map['id'];
    this.name = map['name'];
    this.description = map['description'];
    this.price = map['price'];
    this.image = map['image'];
    this.quantity = map['quantity'];
    this.category = map['category'];
  }
}
