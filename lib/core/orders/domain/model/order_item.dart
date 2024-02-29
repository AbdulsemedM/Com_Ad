import 'dart:convert';

OrderItems orderItemsFromJson(String str) =>
    OrderItems.fromJson(json.decode(str));

String orderItemsToJson(OrderItems data) => json.encode(data.toJson());

class OrderItems {
  OrderItems({
    num? noOfProduct,
    String? itemOrderRef,
    num? itemId,
  }) {
    _noOfProduct = noOfProduct;
    _itemOrderRef = itemOrderRef;
    _itemId = itemId;
  }

  OrderItems.fromJson(dynamic json) {
    _noOfProduct = json['NoOfProduct'];
    _itemOrderRef = json['ItemOrderRef'];
    _itemId = json['ItemId'];
  }

  num? _noOfProduct;
  String? _itemOrderRef;
  num? _itemId;

  OrderItems copyWith({
    num? noOfProduct,
    String? itemOrderRef,
    num? itemId,
  }) =>
      OrderItems(
        noOfProduct: noOfProduct ?? _noOfProduct,
        itemOrderRef: itemOrderRef ?? _itemOrderRef,
        itemId: itemId ?? _itemId,
      );

  num? get noOfProduct => _noOfProduct;

  String? get itemOrderRef => _itemOrderRef;

  num? get itemId => _itemId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['NoOfProduct'] = _noOfProduct;
    map['ItemOrderRef'] = _itemOrderRef;
    map['ItemId'] = _itemId;
    return map;
  }
}
