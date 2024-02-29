import 'dart:convert';

import '../../domain/model/merchant_order.dart';


OrdersResponseDto ordersResponseDtoFromJson(String str) =>
    OrdersResponseDto.fromJson(json.decode(str));

String ordersResponseDtoToJson(OrdersResponseDto data) =>
    json.encode(data.toJson());

class OrdersResponseDto {
  OrdersResponseDto({
    String? statusDescription,
    List<MerchantOrders>? data,
    String? statusMessage,
    String? statusCode,
  }) {
    _statusDescription = statusDescription;
    _data = data;
    _statusMessage = statusMessage;
    _statusCode = statusCode;
  }

  OrdersResponseDto.fromJson(dynamic json) {
    _statusDescription = json['statusDescription'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(MerchantOrders.fromJson(v));
      });
    }
    _statusMessage = json['statusMessage'];
    _statusCode = json['statusCode'];
  }

  String? _statusDescription;
  List<MerchantOrders>? _data;
  String? _statusMessage;
  String? _statusCode;

  OrdersResponseDto copyWith({
    String? statusDescription,
    List<MerchantOrders>? data,
    String? statusMessage,
    String? statusCode,
  }) =>
      OrdersResponseDto(
        statusDescription: statusDescription ?? _statusDescription,
        data: data ?? _data,
        statusMessage: statusMessage ?? _statusMessage,
        statusCode: statusCode ?? _statusCode,
      );

  String? get statusDescription => _statusDescription;

  List<MerchantOrders>? get data => _data;

  String? get statusMessage => _statusMessage;

  String? get statusCode => _statusCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusDescription'] = _statusDescription;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['statusMessage'] = _statusMessage;
    map['statusCode'] = _statusCode;
    return map;
  }
}



