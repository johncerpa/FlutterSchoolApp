class Person {
  int id;
  String name;
  String username;
  String email;
  Person({this.id, this.name, this.username, this.email});

  Person.initial()
      : id = 0,
        name = '',
        username = '',
        email = '';

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
  }
}
