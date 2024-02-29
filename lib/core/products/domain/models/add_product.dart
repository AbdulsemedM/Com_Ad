import 'dart:convert';

import 'product_feature.dart';

AddProduct addProductFromJson(String str) =>
    AddProduct.fromJson(json.decode(str));

String addProductToJson(AddProduct data) => json.encode(data.toJson());

class AddProduct {
  AddProduct({
    String? countryOfOrigin,
    String? createdBy,
    String? currency,
    String? discountType,
    String? discountValue,
    String? isDiscounted,
    String? manufucturer,
    String? maxOrder,
    String? minOrder,
    String? productCategoryId,
    String? productDescription,
    List<ProductFeature>? productFeaturee,
    String? productName,
    String? productParentCateoryId,
    String? productSubCategoryId,
    String? productType,
    String? quantity,
    String? shortDescription,
    String? soldQuantity,
    String? specialInstruction,
    String? tax,
    String? unitOfMeasure,
    String? unitPrice,
  }) {
    _countryOfOrigin = countryOfOrigin;
    _createdBy = createdBy;
    _currency = currency;
    _discountType = discountType;
    _discountValue = discountValue;
    _isDiscounted = isDiscounted;
    _manufucturer = manufucturer;
    _maxOrder = maxOrder;
    _minOrder = minOrder;
    _productCategoryId = productCategoryId;
    _productDescription = productDescription;
    productFeature = productFeaturee;
    _productName = productName;
    _productParentCateoryId = productParentCateoryId;
    _productSubCategoryId = productSubCategoryId;
    _productType = productType;
    _quantity = quantity;
    _shortDescription = shortDescription;
    _soldQuantity = soldQuantity;
    _specialInstruction = specialInstruction;
    _tax = tax;
    _unitOfMeasure = unitOfMeasure;
    _unitPrice = unitPrice;
  }

  AddProduct.fromJson(dynamic json) {
    _countryOfOrigin = json['countryOfOrigin'];
    _createdBy = json['createdBy'];
    _currency = json['currency'];
    _discountType = json['discountType'];
    if (_discountValue != null) _discountValue = json['discountValue'];
    _isDiscounted = json['isDiscounted'];
    _manufucturer = json['manufucturer'];
    _maxOrder = json['maxOrder'];
    _minOrder = json['minOrder'];
    _productCategoryId = json['productCategoryId'];
    _productDescription = json['productDescription'];
    if (json['productFeature'] != null) {
      productFeature = [];
      json['productFeature'].forEach((v) {
        productFeature?.add(ProductFeature.fromJson(v));
      });
    }
    _productName = json['productName'];
    _productParentCateoryId = json['productParentCateoryId'];
    _productSubCategoryId = json['productSubCategoryId'];
    _productType = json['productType'];
    _quantity = json['quantity'];
    _shortDescription = json['shortDescription'];
    _soldQuantity = json['soldQuantity'];
    _specialInstruction = json['specialInstruction'];
    _tax = json['tax'];
    _unitOfMeasure = json['unitOfMeasure'];
    _unitPrice = json['unitPrice'];
  }

  String? _countryOfOrigin;
  String? _createdBy;
  String? _currency;
  String? _discountType;
  String? _discountValue;
  String? _isDiscounted;
  String? _manufucturer;
  String? _maxOrder;
  String? _minOrder;
  String? _productCategoryId;
  String? _productDescription;
  List<ProductFeature>? productFeature;
  String? _productName;
  String? _productParentCateoryId;
  String? _productSubCategoryId;
  String? _productType;
  String? _quantity;
  String? _shortDescription;
  String? _soldQuantity;
  String? _specialInstruction;
  String? _tax;
  String? _unitOfMeasure;
  String? _unitPrice;

  AddProduct copyWith({
    String? countryOfOrigin,
    String? createdBy,
    String? currency,
    String? discountType,
    String? discountValue,
    String? isDiscounted,
    String? manufucturer,
    String? maxOrder,
    String? minOrder,
    String? productCategoryId,
    String? productDescription,
    List<ProductFeature>? productFeaturee,
    String? productName,
    String? productParentCateoryId,
    String? productSubCategoryId,
    String? productType,
    String? quantity,
    String? shortDescription,
    String? soldQuantity,
    String? specialInstruction,
    String? tax,
    String? unitOfMeasure,
    String? unitPrice,
  }) =>
      AddProduct(
        countryOfOrigin: countryOfOrigin ?? _countryOfOrigin,
        createdBy: createdBy ?? _createdBy,
        currency: currency ?? _currency,
        discountType: discountType ?? _discountType,
        discountValue: discountValue ?? _discountValue,
        isDiscounted: isDiscounted ?? _isDiscounted,
        manufucturer: manufucturer ?? _manufucturer,
        maxOrder: maxOrder ?? _maxOrder,
        minOrder: minOrder ?? _minOrder,
        productCategoryId: productCategoryId ?? _productCategoryId,
        productDescription: productDescription ?? _productDescription,
        productFeaturee: productFeaturee ?? productFeature,
        productName: productName ?? _productName,
        productParentCateoryId:
            productParentCateoryId ?? _productParentCateoryId,
        productSubCategoryId: productSubCategoryId ?? _productSubCategoryId,
        productType: productType ?? _productType,
        quantity: quantity ?? _quantity,
        shortDescription: shortDescription ?? _shortDescription,
        soldQuantity: soldQuantity ?? _soldQuantity,
        specialInstruction: specialInstruction ?? _specialInstruction,
        tax: tax ?? _tax,
        unitOfMeasure: unitOfMeasure ?? _unitOfMeasure,
        unitPrice: unitPrice ?? _unitPrice,
      );

  String? get countryOfOrigin => _countryOfOrigin;

  String? get createdBy => _createdBy;

  set createdBy(String? name) {
    _createdBy = name;
  }

  String? get currency => _currency;

  String? get discountType => _discountType;

  String? get discountValue => _discountValue;

  String? get isDiscounted => _isDiscounted;

  String? get manufucturer => _manufucturer;

  String? get maxOrder => _maxOrder;

  String? get minOrder => _minOrder;

  String? get productCategoryId => _productCategoryId;

  String? get productDescription => _productDescription;

  String? get productName => _productName;

  String? get productParentCateoryId => _productParentCateoryId;

  String? get productSubCategoryId => _productSubCategoryId;

  String? get productType => _productType;

  String? get quantity => _quantity;

  String? get shortDescription => _shortDescription;

  String? get soldQuantity => _soldQuantity;

  String? get specialInstruction => _specialInstruction;

  String? get tax => _tax;

  String? get unitOfMeasure => _unitOfMeasure;

  String? get unitPrice => _unitPrice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['countryOfOrigin'] = _countryOfOrigin;
    map['createdBy'] = _createdBy;
    map['currency'] = _currency;
    map['discountType'] = _discountType;
    map['discountValue'] = _discountValue;
    map['isDiscounted'] = _isDiscounted;
    map['manufucturer'] = _manufucturer;
    map['maxOrder'] = _maxOrder;
    map['minOrder'] = _minOrder;
    map['productCategoryId'] = _productCategoryId;
    map['productDescription'] = _productDescription;
    if (productFeature != null) {
      map['productFeature'] = productFeature?.map((v) => v.toJson()).toList();
    }
    map['productName'] = _productName;
    map['productParentCateoryId'] = _productParentCateoryId;
    map['productSubCategoryId'] = _productSubCategoryId;
    map['productType'] = _productType;
    map['quantity'] = _quantity;
    map['shortDescription'] = _shortDescription;
    map['soldQuantity'] = _soldQuantity;
    map['specialInstruction'] = _specialInstruction;
    map['tax'] = _tax;
    map['unitOfMeasure'] = _unitOfMeasure;
    map['unitPrice'] = _unitPrice;
    return map;
  }
}

