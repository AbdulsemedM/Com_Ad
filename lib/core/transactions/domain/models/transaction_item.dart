import 'dart:convert';

TransactionItem listFromJson(String str) =>
    TransactionItem.fromJson(json.decode(str));

String listToJson(TransactionItem data) => json.encode(data.toJson());

class TransactionItem {
  TransactionItem({
    String? account,
    String? narration,
    String? transDate,
    num? amount,
    String? currency,
    String? transRef,
    String? transType,
    num? id,
    String? drCr,
  }) {
    _account = account;
    _narration = narration;
    _transDate = transDate;
    _amount = amount;
    _currency = currency;
    _transRef = transRef;
    _transType = transType;
    _id = id;
    _drCr = drCr;
  }

  TransactionItem.fromJson(dynamic json) {
    _account = json['Account'];
    _narration = json['Narration'];
    _transDate = json['TransDate'];
    _amount = json['Amount'];
    _currency = json['Currency'];
    _transRef = json['TransRef'];
    _transType = json['TransType'];
    _id = json['Id'];
    _drCr = json['DrCr'];
  }

  String? _account;
  String? _narration;
  String? _transDate;
  num? _amount;
  String? _currency;
  String? _transRef;
  String? _transType;
  num? _id;
  String? _drCr;

  TransactionItem copyWith({
    String? account,
    String? narration,
    String? transDate,
    num? amount,
    String? currency,
    String? transRef,
    String? transType,
    num? id,
    String? drCr,
  }) =>
      TransactionItem(
        account: account ?? _account,
        narration: narration ?? _narration,
        transDate: transDate ?? _transDate,
        amount: amount ?? _amount,
        currency: currency ?? _currency,
        transRef: transRef ?? _transRef,
        transType: transType ?? _transType,
        id: id ?? _id,
        drCr: drCr ?? _drCr,
      );

  String? get account => _account;

  String? get narration => _narration;

  String? get transDate => _transDate;

  num? get amount => _amount;

  String? get currency => _currency;

  String? get transRef => _transRef;

  String? get transType => _transType;

  num? get id => _id;

  String? get drCr => _drCr;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Account'] = _account;
    map['Narration'] = _narration;
    map['TransDate'] = _transDate;
    map['Amount'] = _amount;
    map['Currency'] = _currency;
    map['TransRef'] = _transRef;
    map['TransType'] = _transType;
    map['Id'] = _id;
    map['DrCr'] = _drCr;
    return map;
  }
}
