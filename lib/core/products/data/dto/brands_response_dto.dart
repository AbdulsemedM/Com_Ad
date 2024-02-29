import 'dart:convert';

import '../../domain/models/brand.dart';

BrandsResponseDto brandsResponseDtoFromJson(String str) =>
    BrandsResponseDto.fromJson(json.decode(str));

String brandsResponseDtoToJson(BrandsResponseDto data) =>
    json.encode(data.toJson());

class BrandsResponseDto {
  BrandsResponseDto({
    String? statusDescription,
    List<Brand>? details,
    String? statusMessage,
    String? statusCode,
  }) {
    _statusDescription = statusDescription;
    _details = details;
    _statusMessage = statusMessage;
    _statusCode = statusCode;
  }

  BrandsResponseDto.fromJson(dynamic json) {
    _statusDescription = json['statusDescription'];
    if (json['details'] != null) {
      _details = [];
      json['details'].forEach((v) {
        _details?.add(Brand.fromJson(v));
      });
    }
    _statusMessage = json['statusMessage'];
    _statusCode = json['statusCode'];
  }

  String? _statusDescription;
  List<Brand>? _details;
  String? _statusMessage;
  String? _statusCode;

  BrandsResponseDto copyWith({
    String? statusDescription,
    List<Brand>? details,
    String? statusMessage,
    String? statusCode,
  }) =>
      BrandsResponseDto(
        statusDescription: statusDescription ?? _statusDescription,
        details: details ?? _details,
        statusMessage: statusMessage ?? _statusMessage,
        statusCode: statusCode ?? _statusCode,
      );

  String? get statusDescription => _statusDescription;

  List<Brand>? get details => _details;

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
