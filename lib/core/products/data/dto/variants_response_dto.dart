import 'dart:convert';

import '../../domain/models/variant.dart';

VariantsResponseDto variantsResponseDtoFromJson(String str) =>
    VariantsResponseDto.fromJson(json.decode(str));

String variantsResponseDtoToJson(VariantsResponseDto data) =>
    json.encode(data.toJson());

class VariantsResponseDto {
  VariantsResponseDto({
    String? statusDescription,
    List<ProductVariant>? details,
    String? statusMessage,
    String? statusCode,
  }) {
    _statusDescription = statusDescription;
    _details = details;
    _statusMessage = statusMessage;
    _statusCode = statusCode;
  }

  VariantsResponseDto.fromJson(dynamic json) {
    _statusDescription = json['statusDescription'];
    if (json['details'] != null) {
      _details = [];
      json['details'].forEach((v) {
        _details?.add(ProductVariant.fromJson(v));
      });
    }
    _statusMessage = json['statusMessage'];
    _statusCode = json['statusCode'];
  }

  String? _statusDescription;
  List<ProductVariant>? _details;
  String? _statusMessage;
  String? _statusCode;

  VariantsResponseDto copyWith({
    String? statusDescription,
    List<ProductVariant>? details,
    String? statusMessage,
    String? statusCode,
  }) =>
      VariantsResponseDto(
        statusDescription: statusDescription ?? _statusDescription,
        details: details ?? _details,
        statusMessage: statusMessage ?? _statusMessage,
        statusCode: statusCode ?? _statusCode,
      );

  String? get statusDescription => _statusDescription;

  List<ProductVariant>? get details => _details;

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
