class OrderModel {
  late int id, customerId, pickerId;
  String?  totalCase, pickerStatus,dateAssignIt;
  num? totalAmount, pickedQuantity, approvedQuantity,progress;
  
  OrderModel({
    required this.id,
    required this.customerId,
    required this.pickerId,
    required this.progress,
    required this.totalCase,
    required this.pickerStatus,
    required this.dateAssignIt,
    required this.totalAmount,
    required this.pickedQuantity,
    required this.approvedQuantity,
  });

  OrderModel.fromJson(Map<dynamic, dynamic> map) {
    id = map['id'];
    customerId = map['customerId'];
    pickerId = map['pickerId'];
    progress = map['progress'];
    totalCase = map['totalCase'];
    pickerStatus = map['pickerStatus'];
    dateAssignIt = map['dateAssignIt'];
    totalAmount = map['totalAmount'];
    pickedQuantity = map['pickedQuantity'];
    approvedQuantity = map['approvedQuantity'];
  }

  toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'pickerId': pickerId,
      'progress': progress,
      'totalCase': totalCase,
      'pickerStatus': pickerStatus,
      'dateAssignIt': dateAssignIt,
      'totalAmount': totalAmount,
      'pickedQuantity': pickedQuantity,
      'approvedQuantity': approvedQuantity,
    };
  }
}

// class ProductModelForOrder {
//   late String name;
//   // late int id;
//   late num weight, price, totalamount, totalweight, productscount;
//   // late bool available;
//   ProductModelForOrder({
//     // required this.id,
//     required this.totalamount,
//     required this.name,
//     required this.totalweight,
//     required this.weight,
//     required this.price,
//     required this.productscount,
//   });

//   ProductModelForOrder.fromJson(Map<dynamic, dynamic> map) {
//     // id = map['id'];
//     totalamount = map['totalamount'];
//     name = map['name'];
//     totalweight = map['totalweight'];
//     weight = map['weight'];
//     price = map['price'];
//     productscount = map['productscount'];
//   }

//   toJson() {
//     return {
//       // 'id': id,
//       'totalamount': totalamount,
//       'name': name,
//       'totalweight': totalweight,
//       'weight': weight,
//       'price': price,
//       'productscount': productscount,
//     };
//   }
// }
