// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ItemModel {
  final int orderItemId;
  final String orderItemRef;
  final String itemName;
  final String itemImageUrl;
  final String briefDescription;
  final int quantity;
  final String orderedDateTime;
  ItemModel({
    required this.orderItemId,
    required this.orderItemRef,
    required this.itemName,
    required this.itemImageUrl,
    required this.briefDescription,
    required this.quantity,
    required this.orderedDateTime,
  });

  ItemModel copyWith({
    int? orderItemId,
    String? orderItemRef,
    String? itemName,
    String? itemImageUrl,
    String? briefDescription,
    int? quantity,
    String? orderedDateTime,
  }) {
    return ItemModel(
      orderItemId: orderItemId ?? this.orderItemId,
      orderItemRef: orderItemRef ?? this.orderItemRef,
      itemName: itemName ?? this.itemName,
      itemImageUrl: itemImageUrl ?? this.itemImageUrl,
      briefDescription: briefDescription ?? this.briefDescription,
      quantity: quantity ?? this.quantity,
      orderedDateTime: orderedDateTime ?? this.orderedDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderItemId': orderItemId,
      'orderItemRef': orderItemRef,
      'itemName': itemName,
      'itemImageUrl': itemImageUrl,
      'briefDescription': briefDescription,
      'quantity': quantity,
      'orderedDateTime': orderedDateTime,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      orderItemId: map['orderItemId'] as int,
      orderItemRef: map['orderItemRef'] as String,
      itemName: map['itemName'] as String,
      itemImageUrl: map['itemImageUrl'] as String,
      briefDescription: map['briefDescription'] as String,
      quantity: map['quantity'] as int,
      orderedDateTime: map['orderedDateTime'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemModel.fromJson(String source) =>
      ItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemModel(orderItemId: $orderItemId, orderItemRef: $orderItemRef, itemName: $itemName, itemImageUrl: $itemImageUrl, briefDescription: $briefDescription, quantity: $quantity, orderedDateTime: $orderedDateTime)';
  }

  @override
  bool operator ==(covariant ItemModel other) {
    if (identical(this, other)) return true;

    return other.orderItemId == orderItemId &&
        other.orderItemRef == orderItemRef &&
        other.itemName == itemName &&
        other.itemImageUrl == itemImageUrl &&
        other.briefDescription == briefDescription &&
        other.quantity == quantity &&
        other.orderedDateTime == orderedDateTime;
  }

  @override
  int get hashCode {
    return orderItemId.hashCode ^
        orderItemRef.hashCode ^
        itemName.hashCode ^
        itemImageUrl.hashCode ^
        briefDescription.hashCode ^
        quantity.hashCode ^
        orderedDateTime.hashCode;
  }
}
