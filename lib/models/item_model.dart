class Item {
  final int? id;
  final String? number;

  Item({
    this.id,
    this.number,
  });

  Item.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        number = json['name'];

  // @override
  // toString() => "{id: $id}, {name: $name},{rate: $rate},";
  @override
  toString() => "{id: $id}, {name: $number}";
}
