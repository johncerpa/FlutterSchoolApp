class User {
  String name;
  String username;
  String token;

  User({this.name, this.username, this.token});

  User.initial()
      : name = '',
        username = '',
        token = '';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'],
      username: json['username'],
      name: json['name'],
    );
  }
}
