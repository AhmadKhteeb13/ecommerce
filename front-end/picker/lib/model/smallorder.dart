class smallorder {
  late int orderId,
                productId,
                pricePeices,
                pickedQuantity,
                orderedQuantity,
                approvedQuantity;
  late String message;
  smallorder(
      {required this.orderId,
      required this.productId,
      required this.pricePeices,
      required this.pickedQuantity,
      required this.orderedQuantity,
      required this.approvedQuantity,
      required this.message
      });

  smallorder.fromJson(Map<dynamic, dynamic> map) {
    orderId = map['orderId'];
    productId = map['productId'];
    pricePeices = map['pricePeices'];
    pickedQuantity = map['pickedQuantity'];
    orderedQuantity = map['orderedQuantity'];
    approvedQuantity = map['approvedQuantity'];
    message = map['message'];
  }

  toJson() {
    return {
      'orderId': orderId,
      'productId': productId,
      'pricePeices': pricePeices,
      'pickedQuantity': pickedQuantity,
      'orderedQuantity': orderedQuantity,
      'approvedQuantity': approvedQuantity,
      'message': message
    };
  }
}
