class Quote {
  int ID = 0;
  int user_id = 0;
  String description = '';
  static int quotes = 0;

  Quote({required this.ID, required this.description, required this.user_id});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
        ID: int.parse(json['ID']),
        description: json['description'] as String,
        user_id: int.parse(json['user_id']));
  }

  int get getID => ID;
  int get getUserID => user_id;
  String get getDescription => description;

  set setID(int id) {
    this.ID = id;
  }

  set setDescription(String description) {
    this.description = description;
  }

  Map<String, dynamic> fromDataToMap() {
    var map = Map<String, dynamic>();
    map['id'] = this.ID;
    map['description'] = this.description;
    return map;
  }

  fromMapToData(Map<String, dynamic> map) {
    this.ID = map['id'];
    this.description = map['description'];
  }
}
