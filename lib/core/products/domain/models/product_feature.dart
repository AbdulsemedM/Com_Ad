import 'dart:convert';

ProductFeature productFeatureFromJson(String str) =>
    ProductFeature.fromJson(json.decode(str));

String productFeatureToJson(ProductFeature data) => json.encode(data.toJson());

class ProductFeature {
  ProductFeature({
    num? featureId,
    String? featureValue,
    String? unitOfMeasure,
  }) {
    _featureId = featureId;
    _featureValue = featureValue;
    _unitOfMeasure = unitOfMeasure;
  }

  ProductFeature.fromJson(dynamic json) {
    _featureId = json['FeatureId'];
    _featureValue = json['FeatureValue'];
    _unitOfMeasure = json['UnitOfMeasure'];
  }

  num? _featureId;
  String? _featureValue;
  String? _unitOfMeasure;

  ProductFeature copyWith({
    num? featureId,
    String? featureValue,
    String? unitOfMeasure,
  }) =>
      ProductFeature(
        featureId: featureId ?? _featureId,
        featureValue: featureValue ?? _featureValue,
        unitOfMeasure: unitOfMeasure ?? _unitOfMeasure,
      );

  num? get featureId => _featureId;

  String? get featureValue => _featureValue;

  String? get unitOfMeasure => _unitOfMeasure;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['FeatureId'] = _featureId;
    map['FeatureValue'] = _featureValue;
    map['UnitOfMeasure'] = _unitOfMeasure;
    return map;
  }
}
