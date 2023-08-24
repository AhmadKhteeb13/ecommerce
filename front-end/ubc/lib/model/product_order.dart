class ProductOrder {
  int productId, orderedQuantity;
  String image, name, categoryname;
  num weight, price, available;
  ProductOrder({
    required this.orderedQuantity, 
    required this.productId,
    required this.available,
    required this.image,
    required this.name,
    required this.price,
    required this.weight,
    required this.categoryname
    });
}
