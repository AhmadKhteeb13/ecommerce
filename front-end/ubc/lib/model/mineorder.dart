import 'mineproduct.dart';

class mineorder {
  List<mineproduct> products;
  num totalAmount;
  mineorder({required this.totalAmount, required this.products});
  
  Map<dynamic, dynamic> toJson() {
    return {
      'products': products.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
    };
  }
}
