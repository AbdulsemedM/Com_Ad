import 'dart:convert';

import 'order_item.dart';

MerchantOrders dataFromJson(String str) =>
    MerchantOrders.fromJson(json.decode(str));

String dataToJson(MerchantOrders data) => json.encode(data.toJson());

class MerchantOrders {
  MerchantOrders({
    String? orderRef,
    String? customerName,
    List<OrderItems>? orderItems,
    String? orderDate,
  }) {
    _orderRef = orderRef;
    _customerName = customerName;
    _orderItems = orderItems;
    _orderDate = orderDate;
  }

  MerchantOrders.fromJson(dynamic json) {
    _orderRef = json['OrderRef'];
    _customerName = json['CustomerName'];
    if (json['orderItems'] != null) {
      _orderItems = [];
      json['orderItems'].forEach((v) {
        _orderItems?.add(OrderItems.fromJson(v));
      });
    }
    _orderDate = json['OrderDate'];
  }

  String? _orderRef;
  String? _customerName;
  List<OrderItems>? _orderItems;
  String? _orderDate;

  MerchantOrders copyWith({
    String? orderRef,
    String? customerName,
    List<OrderItems>? orderItems,
    String? orderDate,
  }) =>
      MerchantOrders(
        orderRef: orderRef ?? _orderRef,
        customerName: customerName ?? _customerName,
        orderItems: orderItems ?? _orderItems,
        orderDate: orderDate ?? _orderDate,
      );

  String? get orderRef => _orderRef;

  String? get customerName => _customerName;

  List<OrderItems>? get orderItems => _orderItems;

  String? get orderDate => _orderDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['OrderRef'] = _orderRef;
    map['CustomerName'] = _customerName;
    if (_orderItems != null) {
      map['orderItems'] = _orderItems?.map((v) => v.toJson()).toList();
    }
    map['OrderDate'] = _orderDate;

    return map;
  }
}
