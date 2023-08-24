class ProductModel {
  late int id, categorytId, available, trending,weight;
  late int  price;
  late String name, image, code, description;
  ProductModel(
      {required this.id,
      required this.available,
      required this.categorytId,
      required this.trending,
      required this.weight,
      required this.price,
      required this.name,
      required this.image,
      required this.code,
      required this.description
      });

  ProductModel.fromJson(Map<dynamic, dynamic> map) {
    id = map['id'];
    available = map['available'];
    categorytId = map['categorytId'];
    trending = map['trending'];
    weight = map['weight'];
    price = map['price'];
    name = map['name'];
    image = map['image'];
    code = map['code'];
    description = map['description'];
  }

  toJson() {
    return {
      'id': id,
      'available': available,
      'categorytId': categorytId,
      'trending': trending,
      'weight': weight,
      'price': price,
      'name': name,
      'image': image,
      'code': code,
      'description' : description
    };
  }
}
