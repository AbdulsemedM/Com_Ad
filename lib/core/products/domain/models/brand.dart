import 'dart:convert';

Brand detailsFromJson(String str) => Brand.fromJson(json.decode(str));

String detailsToJson(Brand data) => json.encode(data.toJson());

class Brand {
  Brand({
    String? mobileImage,
    String? webImage,
    String? webThumbnail,
    String? name,
    num? parentCategoryId,
    num? id,
    String? mobileThumbnail,
  }) {
    _mobileImage = mobileImage;
    _webImage = webImage;
    _webThumbnail = webThumbnail;
    _name = name;
    _parentCategoryId = parentCategoryId;
    _id = id;
    _mobileThumbnail = mobileThumbnail;
  }

  Brand.fromJson(dynamic json) {
    _mobileImage = json['mobileImage'];
    _webImage = json['webImage'];
    _webThumbnail = json['webThumbnail'];
    _name = json['name'];
    _parentCategoryId = json['parentCategoryId'];
    _id = json['id'];
    _mobileThumbnail = json['mobileThumbnail'];
  }

  String? _mobileImage;
  String? _webImage;
  String? _webThumbnail;
  String? _name;
  num? _parentCategoryId;
  num? _id;
  String? _mobileThumbnail;

  Brand copyWith({
    String? mobileImage,
    String? webImage,
    String? webThumbnail,
    String? name,
    num? parentCategoryId,
    num? id,
    String? mobileThumbnail,
  }) =>
      Brand(
        mobileImage: mobileImage ?? _mobileImage,
        webImage: webImage ?? _webImage,
        webThumbnail: webThumbnail ?? _webThumbnail,
        name: name ?? _name,
        parentCategoryId: parentCategoryId ?? _parentCategoryId,
        id: id ?? _id,
        mobileThumbnail: mobileThumbnail ?? _mobileThumbnail,
      );

  String? get mobileImage => _mobileImage;

  String? get webImage => _webImage;

  String? get webThumbnail => _webThumbnail;

  String? get name => _name;

  num? get parentCategoryId => _parentCategoryId;

  num? get id => _id;

  String? get mobileThumbnail => _mobileThumbnail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobileImage'] = _mobileImage;
    map['webImage'] = _webImage;
    map['webThumbnail'] = _webThumbnail;
    map['name'] = _name;
    map['parentCategoryId'] = _parentCategoryId;
    map['id'] = _id;
    map['mobileThumbnail'] = _mobileThumbnail;
    return map;
  }
}
