import 'dart:convert';

ProductVariant detailsFromJson(String str) => ProductVariant.fromJson(json.decode(str));

String detailsToJson(ProductVariant data) => json.encode(data.toJson());

class ProductVariant {
  ProductVariant({
    String? variableType,
    String? unitOfMeasure,
    String? featureName,
    num? subCategoryId,
    num? featureId,
  }) {
    _variableType = variableType;
    _unitOfMeasure = unitOfMeasure;
    _featureName = featureName;
    _subCategoryId = subCategoryId;
    _featureId = featureId;
  }

  ProductVariant.fromJson(dynamic json) {
    _variableType = json['variableType'];
    _unitOfMeasure = json['unitOfMeasure'];
    _featureName = json['featureName'];
    _subCategoryId = json['subCategoryId'];
    _featureId = json['featureId'];
  }

  String? _variableType;
  String? _unitOfMeasure;
  String? _featureName;
  num? _subCategoryId;
  num? _featureId;

  ProductVariant copyWith({
    String? variableType,
    String? unitOfMeasure,
    String? featureName,
    num? subCategoryId,
    num? featureId,
  }) =>
      ProductVariant(
        variableType: variableType ?? _variableType,
        unitOfMeasure: unitOfMeasure ?? _unitOfMeasure,
        featureName: featureName ?? _featureName,
        subCategoryId: subCategoryId ?? _subCategoryId,
        featureId: featureId ?? _featureId,
      );

  String? get variableType => _variableType;

  String? get unitOfMeasure => _unitOfMeasure;

  String? get featureName => _featureName;

  num? get subCategoryId => _subCategoryId;

  num? get featureId => _featureId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['variableType'] = _variableType;
    map['unitOfMeasure'] = _unitOfMeasure;
    map['featureName'] = _featureName;
    map['subCategoryId'] = _subCategoryId;
    map['featureId'] = _featureId;
    return map;
  }
}
