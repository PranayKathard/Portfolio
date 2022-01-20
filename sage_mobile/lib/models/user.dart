class User {
  static User defaultUser = User(
      ID: 0,
      email: 'default',
      name: 'default',
      password: 'default',
      userType: 'default');

  int ID;
  String name;
  String email;
  String password;
  String userType;

  User(
      {required this.ID,
      required this.email,
      required this.name,
      required this.password,
      required this.userType});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        ID: int.parse(json['ID']),
        name: json['name'] as String,
        email: json['email'] as String,
        password: json['password'] as String,
        userType: json['user_type'] as String);
  }

  int get getID => ID;
  String get getName => name;
  String get getEmail => email;
  String get getPassword => password;
  String get getUserType => userType;

  set setName(String name) {
    this.name = name;
  }

  set setEmail(String email) {
    this.email = email;
  }

  set setPassword(String password) {
    this.password = password;
  }

  set setUserType(String userType) {
    this.userType = userType;
  }

}
