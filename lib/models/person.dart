class Person {
  int id;
  String name;
  String username;
  String email;
  String phone;
  String city;
  String country;
  String birthday;
  Person(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.phone,
      this.city,
      this.country,
      this.birthday});

  Person.initial()
      : id = 0,
        name = '',
        username = '',
        email = '',
        phone = '',
        city = '',
        country = '',
        birthday = '';

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    city = json['city'];
    country = json['country'];
    birthday = json['birthday'];
  }
}
