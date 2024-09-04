import 'dart:convert';

import '../../domain/models/transaction_item.dart';

TransactionResponseDto transactionResponseDtoFromJson(String str) =>
    TransactionResponseDto.fromJson(json.decode(str));

String transactionResponseDtoToJson(TransactionResponseDto data) =>
    json.encode(data.toJson());

class TransactionResponseDto {
  TransactionResponseDto({
    String? status,
    String? message,
    List<TransactionItem>? list,
  }) {
    _status = status;
    _message = message;
    _list = list;
  }

  TransactionResponseDto.fromJson(dynamic json) {
    _status = json['Status'];
    _message = json['Message'];
    if (json['List'] != null) {
      _list = [];
      json['List'].forEach((v) {
        _list?.add(TransactionItem.fromJson(v));
      });
    }
  }

  String? _status;
  String? _message;
  List<TransactionItem>? _list;

  TransactionResponseDto copyWith({
    String? status,
    String? message,
    List<TransactionItem>? list,
  }) =>
      TransactionResponseDto(
        status: status ?? _status,
        message: message ?? _message,
        list: list ?? _list,
      );

  String? get status => _status;

  String? get message => _message;

  List<TransactionItem>? get list => _list;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Status'] = _status;
    map['Message'] = _message;
    if (_list != null) {
      map['List'] = _list?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
