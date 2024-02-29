import 'dart:convert';

import '../../domain/models/unit_of_measure.dart';

UomResponseDto uomResponseDtoFromJson(String str) =>
    UomResponseDto.fromJson(json.decode(str));

String uomResponseDtoToJson(UomResponseDto data) => json.encode(data.toJson());

class UomResponseDto {
  UomResponseDto({
    String? statusDescription,
    List<Uom>? details,
    String? statusMessage,
    String? statusCode,
  }) {
    _statusDescription = statusDescription;
    _details = details;
    _statusMessage = statusMessage;
    _statusCode = statusCode;
  }

  UomResponseDto.fromJson(dynamic json) {
    _statusDescription = json['statusDescription'];
    if (json['details'] != null) {
      _details = [];
      json['details'].forEach((v) {
        _details?.add(Uom.fromJson(v));
      });
    }
    _statusMessage = json['statusMessage'];
    _statusCode = json['statusCode'];
  }

  String? _statusDescription;
  List<Uom>? _details;
  String? _statusMessage;
  String? _statusCode;

  UomResponseDto copyWith({
    String? statusDescription,
    List<Uom>? details,
    String? statusMessage,
    String? statusCode,
  }) =>
      UomResponseDto(
        statusDescription: statusDescription ?? _statusDescription,
        details: details ?? _details,
        statusMessage: statusMessage ?? _statusMessage,
        statusCode: statusCode ?? _statusCode,
      );

  String? get statusDescription => _statusDescription;

  List<Uom>? get details => _details;

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

