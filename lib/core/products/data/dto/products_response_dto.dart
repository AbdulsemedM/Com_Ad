import 'dart:convert';

import '../../domain/models/product.dart';

ProductsResponseDto productsResponseDtoFromJson(String str) =>
    ProductsResponseDto.fromJson(json.decode(str));

String productsResponseDtoToJson(ProductsResponseDto data) =>
    json.encode(data.toJson());

class ProductsResponseDto {
  ProductsResponseDto({
    String? statusDescription,
    List<Product>? details,
    String? statusMessage,
    String? statusCode,
  }) {
    _statusDescription = statusDescription;
    _details = details;
    _statusMessage = statusMessage;
    _statusCode = statusCode;
  }

  ProductsResponseDto.fromJson(dynamic json) {
    _statusDescription = json['statusDescription'];
    if (json['details'] != null) {
      _details = [];
      json['details'].forEach((v) {
        _details?.add(Product.fromJson(v));
      });
    }
    _statusMessage = json['statusMessage'];
    _statusCode = json['statusCode'];
  }

  String? _statusDescription;
  List<Product>? _details;
  String? _statusMessage;
  String? _statusCode;

  ProductsResponseDto copyWith({
    String? statusDescription,
    List<Product>? details,
    String? statusMessage,
    String? statusCode,
  }) =>
      ProductsResponseDto(
        statusDescription: statusDescription ?? _statusDescription,
        details: details ?? _details,
        statusMessage: statusMessage ?? _statusMessage,
        statusCode: statusCode ?? _statusCode,
      );

  String? get statusDescription => _statusDescription;

  List<Product>? get details => _details;

  String? get statusMessage => _statusMessage;

  String? get statusCode => _statusCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusDescription'] = _statusDescription;
    if (_details != null) {
      map['details'] = _details?.map((v) => v.toJson()).toList();
    }
    map['statusMessage'] = _statusMessage;
    map['statusCode'] = _statusCode;
    return map;
  }
}
