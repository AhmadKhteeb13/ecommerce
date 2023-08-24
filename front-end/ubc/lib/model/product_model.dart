class ProductModel {
  late String name, image, description;
  // late Color color;
  late int id,categorytId;
  late num weight, price, available;
  // late bool available;
  ProductModel({
    required this.id,
    required this.categorytId,
    required this.name,
    required this.image,
    required this.weight,
    required this.price,
    required this.available,
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
      'description': description,
    };
  }
}
