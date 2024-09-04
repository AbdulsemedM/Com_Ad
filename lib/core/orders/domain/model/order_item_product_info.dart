import 'dart:convert';

OrderItemProductInfo orderItemProuctInfoFromJson(String str) =>
    OrderItemProductInfo.fromJson(json.decode(str));

String orderItemProuctInfoToJson(OrderItemProductInfo data) =>
    json.encode(data.toJson());

class OrderItemProductInfo {
  OrderItemProductInfo({
    String? status,
    String? mobileImage,
    String? webImage,
    String? webThumbnail,
    num? productParentCategoryId,
    num? productId,
    String? mobileThumbnail,
    String? productDescription,
    SubProductInfo? subProductInfo,
    String? productName,
    String? shortDescription,
  }) {
    _status = status;
    _mobileImage = mobileImage;
    _webImage = webImage;
    _webThumbnail = webThumbnail;
    _productParentCategoryId = productParentCategoryId;
    _productId = productId;
    _mobileThumbnail = mobileThumbnail;
    _productDescription = productDescription;
    _subProductInfo = subProductInfo;
    _productName = productName;
    _shortDescription = shortDescription;
  }

  OrderItemProductInfo.fromJson(dynamic json) {
    _status = json['Status'];
    _mobileImage = json['mobileImage'];
    _webImage = json['webImage'];
    _webThumbnail = json['webThumbnail'];
    _productParentCategoryId = json['ProductParentCategoryId'];
    _productId = json['ProductId'];
    _mobileThumbnail = json['mobileThumbnail'];
    _productDescription = json['ProductDescription'];
    _subProductInfo = json['subProductInfo'] != null
        ? SubProductInfo.fromJson(json['subProductInfo'])
        : null;
    _productName = json['productName'];
    _shortDescription = json['ShortDescription'];
  }

  String? _status;
  String? _mobileImage;
  String? _webImage;
  String? _webThumbnail;
  num? _productParentCategoryId;
  num? _productId;
  String? _mobileThumbnail;
  String? _productDescription;
  SubProductInfo? _subProductInfo;
  String? _productName;
  String? _shortDescription;
  String? shippingStatus;
  String? quantity;

  OrderItemProductInfo copyWith({
    String? status,
    String? mobileImage,
    String? webImage,
    String? webThumbnail,
    num? productParentCategoryId,
    num? productId,
    String? mobileThumbnail,
    String? productDescription,
    SubProductInfo? subProductInfo,
    String? productName,
    String? shortDescription,
  }) =>
      OrderItemProductInfo(
        status: status ?? _status,
        mobileImage: mobileImage ?? _mobileImage,
        webImage: webImage ?? _webImage,
        webThumbnail: webThumbnail ?? _webThumbnail,
        productParentCategoryId:
            productParentCategoryId ?? _productParentCategoryId,
        productId: productId ?? _productId,
        mobileThumbnail: mobileThumbnail ?? _mobileThumbnail,
        productDescription: productDescription ?? _productDescription,
        subProductInfo: subProductInfo ?? _subProductInfo,
        productName: productName ?? _productName,
        shortDescription: shortDescription ?? _shortDescription,
      );

  String? get status => _status;

  String? get mobileImage => _mobileImage;

  String? get webImage => _webImage;

  String? get webThumbnail => _webThumbnail;

  num? get productParentCategoryId => _productParentCategoryId;

  num? get productId => _productId;

  String? get mobileThumbnail => _mobileThumbnail;

  String? get productDescription => _productDescription;

  SubProductInfo? get subProductInfo => _subProductInfo;

  String? get productName => _productName;

  String? get shortDescription => _shortDescription;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Status'] = _status;
    map['mobileImage'] = _mobileImage;
    map['webImage'] = _webImage;
    map['webThumbnail'] = _webThumbnail;
    map['ProductParentCategoryId'] = _productParentCategoryId;
    map['ProductId'] = _productId;
    map['mobileThumbnail'] = _mobileThumbnail;
    map['ProductDescription'] = _productDescription;
    if (_subProductInfo != null) {
      map['subProductInfo'] = _subProductInfo?.toJson();
    }
    map['productName'] = _productName;
    map['ShortDescription'] = _shortDescription;
    return map;
  }
}

SubProductInfo subProductInfoFromJson(String str) =>
    SubProductInfo.fromJson(json.decode(str));

String subProductInfoToJson(SubProductInfo data) => json.encode(data.toJson());

class SubProductInfo {
  SubProductInfo({
    String? mobileImage,
    num? offerPrice,
    List<String>? subProductImages,
    String? webVideo,
    num? discountAmount,
    String? shortDescription,
    List<Features>? features,
    num? unitPrice,
    String? mobileVideo,
    String? webImage,
    String? webThumbnail,
    num? subProductId,
    String? discountType,
    String? mobileThumbnail,
    num? isDiscounted,
    num? discountValue,
    String? discountDescription,
  }) {
    _mobileImage = mobileImage;
    _offerPrice = offerPrice;
    _subProductImages = subProductImages;
    _webVideo = webVideo;
    _discountAmount = discountAmount;
    _shortDescription = shortDescription;
    _features = features;
    _unitPrice = unitPrice;
    _mobileVideo = mobileVideo;
    _webImage = webImage;
    _webThumbnail = webThumbnail;
    _subProductId = subProductId;
    _discountType = discountType;
    _mobileThumbnail = mobileThumbnail;
    _isDiscounted = isDiscounted;
    _discountValue = discountValue;
    _discountDescription = discountDescription;
  }

  SubProductInfo.fromJson(dynamic json) {
    _mobileImage = json['mobileImage'];
    _offerPrice = json['offerPrice'];
    _subProductImages = json['subProductImages'] != null
        ? json['subProductImages'].cast<String>()
        : [];
    _webVideo = json['webVideo'];
    _discountAmount = json['DiscountAmount'];
    _shortDescription = json['ShortDescription'];
    if (json['features'] != null) {
      _features = [];
      json['features'].forEach((v) {
        _features?.add(Features.fromJson(v));
      });
    }
    _unitPrice = json['UnitPrice'];
    _mobileVideo = json['mobileVideo'];
    _webImage = json['webImage'];
    _webThumbnail = json['webThumbnail'];
    _subProductId = json['SubProductId'];
    _discountType = json['DiscountType'];
    _mobileThumbnail = json['mobileThumbnail'];
    _isDiscounted = json['IsDiscounted'];
    _discountValue = json['DiscountValue'];
    _discountDescription = json['discountDescription'];
  }

  String? _mobileImage;
  num? _offerPrice;
  List<String>? _subProductImages;
  String? _webVideo;
  num? _discountAmount;
  String? _shortDescription;
  List<Features>? _features;
  num? _unitPrice;
  String? _mobileVideo;
  String? _webImage;
  String? _webThumbnail;
  num? _subProductId;
  String? _discountType;
  String? _mobileThumbnail;
  num? _isDiscounted;
  num? _discountValue;
  String? _discountDescription;

  SubProductInfo copyWith({
    String? mobileImage,
    num? offerPrice,
    List<String>? subProductImages,
    String? webVideo,
    num? discountAmount,
    String? shortDescription,
    List<Features>? features,
    num? unitPrice,
    String? mobileVideo,
    String? webImage,
    String? webThumbnail,
    num? subProductId,
    String? discountType,
    String? mobileThumbnail,
    num? isDiscounted,
    num? discountValue,
    String? discountDescription,
  }) =>
      SubProductInfo(
        mobileImage: mobileImage ?? _mobileImage,
        offerPrice: offerPrice ?? _offerPrice,
        subProductImages: subProductImages ?? _subProductImages,
        webVideo: webVideo ?? _webVideo,
        discountAmount: discountAmount ?? _discountAmount,
        shortDescription: shortDescription ?? _shortDescription,
        features: features ?? _features,
        unitPrice: unitPrice ?? _unitPrice,
        mobileVideo: mobileVideo ?? _mobileVideo,
        webImage: webImage ?? _webImage,
        webThumbnail: webThumbnail ?? _webThumbnail,
        subProductId: subProductId ?? _subProductId,
        discountType: discountType ?? _discountType,
        mobileThumbnail: mobileThumbnail ?? _mobileThumbnail,
        isDiscounted: isDiscounted ?? _isDiscounted,
        discountValue: discountValue ?? _discountValue,
        discountDescription: discountDescription ?? _discountDescription,
      );

  String? get mobileImage => _mobileImage;

  num? get offerPrice => _offerPrice;

  List<String>? get subProductImages => _subProductImages;

  String? get webVideo => _webVideo;

  num? get discountAmount => _discountAmount;

  String? get shortDescription => _shortDescription;

  List<Features>? get features => _features;

  num? get unitPrice => _unitPrice;

  String? get mobileVideo => _mobileVideo;

  String? get webImage => _webImage;

  String? get webThumbnail => _webThumbnail;

  num? get subProductId => _subProductId;

  String? get discountType => _discountType;

  String? get mobileThumbnail => _mobileThumbnail;

  num? get isDiscounted => _isDiscounted;

  num? get discountValue => _discountValue;

  String? get discountDescription => _discountDescription;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobileImage'] = _mobileImage;
    map['offerPrice'] = _offerPrice;
    map['subProductImages'] = _subProductImages;
    map['webVideo'] = _webVideo;
    map['DiscountAmount'] = _discountAmount;
    map['ShortDescription'] = _shortDescription;
    if (_features != null) {
      map['features'] = _features?.map((v) => v.toJson()).toList();
    }
    map['UnitPrice'] = _unitPrice;
    map['mobileVideo'] = _mobileVideo;
    map['webImage'] = _webImage;
    map['webThumbnail'] = _webThumbnail;
    map['SubProductId'] = _subProductId;
    map['DiscountType'] = _discountType;
    map['mobileThumbnail'] = _mobileThumbnail;
    map['IsDiscounted'] = _isDiscounted;
    map['DiscountValue'] = _discountValue;
    map['discountDescription'] = _discountDescription;
    return map;
  }
}

Features featuresFromJson(String str) => Features.fromJson(json.decode(str));

String featuresToJson(Features data) => json.encode(data.toJson());

class Features {
  Features({
    String? featureValue,
    String? variableType,
    String? unitOfMeasure,
    String? valueUnitOfMeasure,
    String? featureName,
    num? valueId,
    num? featureId,
  }) {
    _featureValue = featureValue;
    _variableType = variableType;
    _unitOfMeasure = unitOfMeasure;
    _valueUnitOfMeasure = valueUnitOfMeasure;
    _featureName = featureName;
    _valueId = valueId;
    _featureId = featureId;
  }

  Features.fromJson(dynamic json) {
    _featureValue = json['featureValue'];
    _variableType = json['variableType'];
    _unitOfMeasure = json['unitOfMeasure'];
    _valueUnitOfMeasure = json['ValueUnitOfMeasure'];
    _featureName = json['featureName'];
    _valueId = json['ValueId'];
    _featureId = json['featureId'];
  }

  String? _featureValue;
  String? _variableType;
  String? _unitOfMeasure;
  String? _valueUnitOfMeasure;
  String? _featureName;
  num? _valueId;
  num? _featureId;

  Features copyWith({
    String? featureValue,
    String? variableType,
    String? unitOfMeasure,
    String? valueUnitOfMeasure,
    String? featureName,
    num? valueId,
    num? featureId,
  }) =>
      Features(
        featureValue: featureValue ?? _featureValue,
        variableType: variableType ?? _variableType,
        unitOfMeasure: unitOfMeasure ?? _unitOfMeasure,
        valueUnitOfMeasure: valueUnitOfMeasure ?? _valueUnitOfMeasure,
        featureName: featureName ?? _featureName,
        valueId: valueId ?? _valueId,
        featureId: featureId ?? _featureId,
      );

  String? get featureValue => _featureValue;

  String? get variableType => _variableType;

  String? get unitOfMeasure => _unitOfMeasure;

  String? get valueUnitOfMeasure => _valueUnitOfMeasure;

  String? get featureName => _featureName;

  num? get valueId => _valueId;

  num? get featureId => _featureId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['featureValue'] = _featureValue;
    map['variableType'] = _variableType;
    map['unitOfMeasure'] = _unitOfMeasure;
    map['ValueUnitOfMeasure'] = _valueUnitOfMeasure;
    map['featureName'] = _featureName;
    map['ValueId'] = _valueId;
    map['featureId'] = _featureId;
    return map;
  }
}
