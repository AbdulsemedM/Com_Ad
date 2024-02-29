import 'dart:convert';

Uom detailsFromJson(String str) => Uom.fromJson(json.decode(str));

String detailsToJson(Uom data) => json.encode(data.toJson());

class Uom {
  Uom({
    String? uoM,
    String? description,
    num? id,
  }) {
    _uoM = uoM;
    _description = description;
    _id = id;
  }

  Uom.fromJson(dynamic json) {
    _uoM = json['UoM'];
    _description = json['Description'];
    _id = json['Id'];
  }

  String? _uoM;
  String? _description;
  num? _id;

  Uom copyWith({
    String? uoM,
    String? description,
    num? id,
  }) =>
      Uom(
        uoM: uoM ?? _uoM,
        description: description ?? _description,
        id: id ?? _id,
      );

  String? get uoM => _uoM;

  String? get description => _description;

  num? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['UoM'] = _uoM;
    map['Description'] = _description;
    map['Id'] = _id;
    return map;
  }
}
