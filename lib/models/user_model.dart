class User {
  final int? id;
  final String? name;
  final String? rate;
  final String? star;
  final String? phoneNumber;

  User({
    this.id,
    this.name,
    this.rate,
    this.star,
    this.phoneNumber,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        phoneNumber = json['description'],
        rate = json['price'],
        star = json['short_description'];

  // @override
  // toString() => "{id: $id}, {name: $name},{rate: $rate},";
  @override
  toString() =>
      "{id: $id}, {name: $name}, {phoneNumber: $phoneNumber}, {star: $star},{rate: $rate},";
}
