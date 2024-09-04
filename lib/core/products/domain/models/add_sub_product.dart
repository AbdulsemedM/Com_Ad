import 'dart:convert';

import 'product_feature.dart';

AddSubProduct addSubProductFromJson(String str) =>
    AddSubProduct.fromJson(json.decode(str));

String addSubProductToJson(AddSubProduct data) => json.encode(data.toJson());

class AddSubProduct {
  AddSubProduct({
    String? createdBy,
    String? discountType,
    String? discountValue,
    String? isDiscounted,
    List<ProductFeature>? productFeature,
    String? productId,
    String? shortDescription,
    String? unitPrice,
  }) {
    _createdBy = createdBy;
    _discountType = discountType;
    _discountValue = discountValue;
    _isDiscounted = isDiscounted;
    _productFeature = productFeature;
    _productId = productId;
    _shortDescription = shortDescription;
    _unitPrice = unitPrice;
  }

  AddSubProduct.fromJson(dynamic json) {
    _createdBy = json['createdBy'];
    _discountType = json['discountType'];
    _discountValue = json['discountValue'];
    _isDiscounted = json['isDiscounted'];
    if (json['productFeature'] != null) {
      _productFeature = [];
      json['productFeature'].forEach((v) {
        _productFeature?.add(ProductFeature.fromJson(v));
      });
    }
    _productId = json['ProductId'];
    _shortDescription = json['shortDescription'];
    _unitPrice = json['unitPrice'];
  }

  String? _createdBy;
  String? _discountType;
  String? _discountValue;
  String? _isDiscounted;
  List<ProductFeature>? _productFeature;
  String? _productId;
  String? _shortDescription;
  String? _unitPrice;

  AddSubProduct copyWith({
    String? createdBy,
    String? discountType,
    String? discountValue,
    String? isDiscounted,
    List<ProductFeature>? productFeature,
    String? productId,
    String? shortDescription,
    String? unitPrice,
  }) =>
      AddSubProduct(
        createdBy: createdBy ?? _createdBy,
        discountType: discountType ?? _discountType,
        discountValue: discountValue ?? _discountValue,
        isDiscounted: isDiscounted ?? _isDiscounted,
        productFeature: productFeature ?? _productFeature,
        productId: productId ?? _productId,
        shortDescription: shortDescription ?? _shortDescription,
        unitPrice: unitPrice ?? _unitPrice,
      );

  String? get createdBy => _createdBy;

  set createdBy(String? name) {
    _createdBy = name;
  }

  String? get discountType => _discountType;

  String? get discountValue => _discountValue;

  String? get isDiscounted => _isDiscounted;

  List<ProductFeature>? get productFeature => _productFeature;

  set productFeature(List<ProductFeature>? pf) {
    _productFeature = pf;
  }

  String? get productId => _productId;

  String? get shortDescription => _shortDescription;

  String? get unitPrice => _unitPrice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['createdBy'] = _createdBy;
    map['discountType'] = _discountType;
    map['discountValue'] = _discountValue;
    map['isDiscounted'] = _isDiscounted;
    if (_productFeature != null) {
      map['productFeature'] = _productFeature?.map((v) => v.toJson()).toList();
    }
    map['ProductId'] = _productId;
    map['shortDescription'] = _shortDescription;
    map['unitPrice'] = _unitPrice;
    return map;
  }
}
