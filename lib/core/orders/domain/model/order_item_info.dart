import 'dart:convert';

import 'package:commercepal_admin_flutter/core/orders/domain/model/shipment_status.dart';

OrderItemInfo orderItemInfoFromJson(String str) =>
    OrderItemInfo.fromJson(json.decode(str));

String orderItemInfoToJson(OrderItemInfo data) => json.encode(data.toJson());

class OrderItemInfo {
  OrderItemInfo({
    num? unitPrice,
    num? shipmentStatus,
    num? subProductId,
    String? createdDate,
    num? productId,
    num? totalAmount,
    num? orderId,
    num? itemId,
    String? subOrderNumber,
  }) {
    _unitPrice = unitPrice;
    _shipmentStatus = shipmentStatus;
    _subProductId = subProductId;
    _createdDate = createdDate;
    _productId = productId;
    _totalAmount = totalAmount;
    _orderId = orderId;
    _itemId = itemId;
    _subOrderNumber = subOrderNumber;
  }

  OrderItemInfo.fromJson(dynamic json) {
    _unitPrice = json['UnitPrice'];
    _shipmentStatus = json['ShipmentStatus'];
    _subProductId = json['SubProductId'];
    _createdDate = json['CreatedDate'];
    _productId = json['ProductId'];
    _totalAmount = json['TotalAmount'];
    _orderId = json['OrderId'];
    _itemId = json['ItemId'];
    _subOrderNumber = json['SubOrderNumber'];
  }

  num? _unitPrice;
  num? _shipmentStatus;
  num? _subProductId;
  String? _createdDate;
  num? _productId;
  num? _totalAmount;
  num? _orderId;
  num? _itemId;
  String? _subOrderNumber;

  OrderItemInfo copyWith({
    num? unitPrice,
    num? shipmentStatus,
    num? subProductId,
    String? createdDate,
    num? productId,
    num? totalAmount,
    num? orderId,
    num? itemId,
    String? subOrderNumber,
  }) =>
      OrderItemInfo(
        unitPrice: unitPrice ?? _unitPrice,
        shipmentStatus: shipmentStatus ?? _shipmentStatus,
        subProductId: subProductId ?? _subProductId,
        createdDate: createdDate ?? _createdDate,
        productId: productId ?? _productId,
        totalAmount: totalAmount ?? _totalAmount,
        orderId: orderId ?? _orderId,
        itemId: itemId ?? _itemId,
        subOrderNumber: subOrderNumber ?? _subOrderNumber,
      );

  num? get unitPrice => _unitPrice;

  num? get shipmentStatus => _shipmentStatus;

  num? get subProductId => _subProductId;

  String? get createdDate => _createdDate;

  num? get productId => _productId;

  num? get totalAmount => _totalAmount;

  num? get orderId => _orderId;

  num? get itemId => _itemId;

  String? get subOrderNumber => _subOrderNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['UnitPrice'] = _unitPrice;
    map['ShipmentStatus'] = _shipmentStatus;
    map['SubProductId'] = _subProductId;
    map['CreatedDate'] = _createdDate;
    map['ProductId'] = _productId;
    map['TotalAmount'] = _totalAmount;
    map['OrderId'] = _orderId;
    map['ItemId'] = _itemId;
    map['SubOrderNumber'] = _subOrderNumber;
    return map;
  }

  ShipmentStatus getShipmentStatus() => switch (shipmentStatus!) {
        102 => ShipmentStatus.readyForPickUp,
        101 => ShipmentStatus.newOrder,
        103 => ShipmentStatus.validateOtp,
        _ => ShipmentStatus.done
      };
}
