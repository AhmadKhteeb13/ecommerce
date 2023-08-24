class ProductModel {
  late int id ;
  late int categorytId;
  late String name;
  late String image;
  late int weight;
  late int price ;
  late int available = 1;
  late int trending = 1;
  late String description;
  ProductModel({
    required this.id,
    required this.categorytId,
    required this.name,
    required this.image,
    required this.weight,
    required this.price,
    required this.available,
    required this.trending,
    required this.description,
  });

  ProductModel.fromJson(Map<dynamic, dynamic> map) {
    id = map['id'];
    categorytId = map['categorytId'];
    name = map['name'];
    image = map['image'];
    weight = map['weight'];
    price = map['price'];
    available = map['available'];
    trending = map['trending'];
    description = map['description'];
  }

  toJson() {
    return {
      'id': id,
      'categorytId': categorytId,
      'name': name,
      'image': image,
      'weight': weight,
      'price': price,
      'available': available,
      'trending': trending,
      'description': description,
    };
  }
}
