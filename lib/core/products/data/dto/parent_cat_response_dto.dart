import 'dart:convert';

ParentCatResponseDto parentCatResponseDtoFromJson(String str) =>
    ParentCatResponseDto.fromJson(json.decode(str));

String parentCatResponseDtoToJson(ParentCatResponseDto data) =>
    json.encode(data.toJson());

class ParentCatResponseDto {
  ParentCatResponseDto({
    String? statusDescription,
    List<ParentCategory>? parentCategories,
    String? statusMessage,
    String? statusCode,
  }) {
    _statusDescription = statusDescription;
    _parentCategories = parentCategories;
    _statusMessage = statusMessage;
    _statusCode = statusCode;
  }

  ParentCatResponseDto.fromJson(dynamic json) {
    _statusDescription = json['statusDescription'];
    if (json['data'] != null) {
      _parentCategories = [];
      json['data'].forEach((v) {
        _parentCategories?.add(ParentCategory.fromJson(v));
      });
    }
    _statusMessage = json['statusMessage'];
    _statusCode = json['statusCode'];
  }

  String? _statusDescription;
  List<ParentCategory>? _parentCategories;
  String? _statusMessage;
  String? _statusCode;

  ParentCatResponseDto copyWith({
    String? statusDescription,
    List<ParentCategory>? data,
    String? statusMessage,
    String? statusCode,
  }) =>
      ParentCatResponseDto(
        statusDescription: statusDescription ?? _statusDescription,
        parentCategories: data ?? _parentCategories,
        statusMessage: statusMessage ?? _statusMessage,
        statusCode: statusCode ?? _statusCode,
      );

  String? get statusDescription => _statusDescription;

  List<ParentCategory>? get parentCategories => _parentCategories;

  String? get statusMessage => _statusMessage;

  String? get statusCode => _statusCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusDescription'] = _statusDescription;
    if (_parentCategories != null) {
      map['data'] = _parentCategories?.map((v) => v.toJson()).toList();
    }
    map['statusMessage'] = _statusMessage;
    map['statusCode'] = _statusCode;
    return map;
  }
}

ParentCategory dataFromJson(String str) =>
    ParentCategory.fromJson(json.decode(str));

String dataToJson(ParentCategory data) => json.encode(data.toJson());

class ParentCategory {
  ParentCategory({
    String? mobileImage,
    String? uniqueName,
    String? webImage,
    String? webThumbnail,
    String? name,
    num? id,
    String? mobileThumbnail,
  }) {
    _mobileImage = mobileImage;
    _uniqueName = uniqueName;
    _webImage = webImage;
    _webThumbnail = webThumbnail;
    _name = name;
    _id = id;
    _mobileThumbnail = mobileThumbnail;
  }

  ParentCategory.fromJson(dynamic json) {
    _mobileImage = json['mobileImage'];
    _uniqueName = json['unique_name'];
    _webImage = json['webImage'];
    _webThumbnail = json['webThumbnail'];
    _name = json['name'];
    _id = json['id'];
    _mobileThumbnail = json['mobileThumbnail'];
  }

  String? _mobileImage;
  String? _uniqueName;
  String? _webImage;
  String? _webThumbnail;
  String? _name;
  num? _id;
  String? _mobileThumbnail;

  ParentCategory copyWith({
    String? mobileImage,
    String? uniqueName,
    String? webImage,
    String? webThumbnail,
    String? name,
    num? id,
    String? mobileThumbnail,
  }) =>
      ParentCategory(
        mobileImage: mobileImage ?? _mobileImage,
        uniqueName: uniqueName ?? _uniqueName,
        webImage: webImage ?? _webImage,
        webThumbnail: webThumbnail ?? _webThumbnail,
        name: name ?? _name,
        id: id ?? _id,
        mobileThumbnail: mobileThumbnail ?? _mobileThumbnail,
      );

  String? get mobileImage => _mobileImage;

  String? get uniqueName => _uniqueName;

  String? get webImage => _webImage;

  String? get webThumbnail => _webThumbnail;

  String? get name => _name;

  num? get id => _id;

  String? get mobileThumbnail => _mobileThumbnail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobileImage'] = _mobileImage;
    map['unique_name'] = _uniqueName;
    map['webImage'] = _webImage;
    map['webThumbnail'] = _webThumbnail;
    map['name'] = _name;
    map['id'] = _id;
    map['mobileThumbnail'] = _mobileThumbnail;
    return map;
  }
}
