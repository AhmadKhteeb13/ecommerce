class OrderModel {
  late int id, customerId;// pickerId;
  String? totalCase, pickerStatus, date, currentStatus;
  num? totalAmount, pickedQuantity, approvedQuantity, progress;

  OrderModel(
      {required this.id,
      required this.customerId,
      // required this.pickerId,
      required this.progress,
      required this.totalCase,
      required this.pickerStatus,
      required this.date,
      required this.totalAmount,
      required this.pickedQuantity,
      required this.approvedQuantity,
      required this.currentStatus});

  OrderModel.fromJson(Map<dynamic, dynamic> map) {
    id = map['id'];
    customerId = map['customerId'];
    // pickerId = map['pickerId'];5
    progress = map['progress'];
    totalCase = map['totalCase'];
    pickerStatus = map['pickerStatus'];
    date = map['created_at'];
    totalAmount = map['totalAmount'];
    pickedQuantity = map['pickedQuantity'];
    approvedQuantity = map['approvedQuantity'];
    currentStatus = map['currentStatus'];
  }

  toJson() {
    return {
      'id': id,
      'customerId': customerId,
      // 'pickerId': pickerId,
      'progress': progress,
      'totalCase': totalCase,
      'pickerStatus': pickerStatus,
      'created_at': date,
      'totalAmount': totalAmount,
      'pickedQuantity': pickedQuantity,
      'approvedQuantity': approvedQuantity,
      'currentStatus': currentStatus
    };
  }
}
