class mineproduct {
  late int productId, orderedQuantity;

  mineproduct(
      {required this.productId,
      required this.orderedQuantity,});

  mineproduct.fromJson(Map<dynamic, dynamic> map) {
    productId = map['productId'];
    orderedQuantity = map['orderedQuantity'];
  }
Map<dynamic, dynamic> toJson() {
    return {
      'productId': productId,
      'orderedQuantity': orderedQuantity
    };
  }
}
