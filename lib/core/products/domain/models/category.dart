import 'dart:convert';

/// mobileImage : ""
/// unique_name : "mobile_phones"
/// webImage : ""
/// webThumbnail : "https://commercepal.s3.af-south-1.amazonaws.com/WebThumbnail/Images/category_1668091712639_271.png"
/// name : "Mobile Phones"
/// parentCategoryId : 1
/// id : 1
/// mobileThumbnail : "https://commercepal.s3.af-south-1.amazonaws.com/MobileThumbnail/Images/Category_1684915827026_357.jpg"
/// categoryId : 1

Category dataFromJson(String str) => Category.fromJson(json.decode(str));

String dataToJson(Category data) => json.encode(data.toJson());

class Category {
  Category({
    String? mobileImage,
    String? uniqueName,
    String? webImage,
    String? webThumbnail,
    String? name,
    num? parentCategoryId,
    num? id,
    String? mobileThumbnail,
    num? categoryId,
  }) {
    _mobileImage = mobileImage;
    _uniqueName = uniqueName;
    _webImage = webImage;
    _webThumbnail = webThumbnail;
    _name = name;
    _parentCategoryId = parentCategoryId;
    _id = id;
    _mobileThumbnail = mobileThumbnail;
    _categoryId = categoryId;
  }

  Category.fromJson(dynamic json) {
    _mobileImage = json['mobileImage'];
    _uniqueName = json['unique_name'];
    _webImage = json['webImage'];
    _webThumbnail = json['webThumbnail'];
    _name = json['name'];
    _parentCategoryId = json['parentCategoryId'];
    _id = json['id'];
    _mobileThumbnail = json['mobileThumbnail'];
    _categoryId = json['categoryId'];
  }

  String? _mobileImage;
  String? _uniqueName;
  String? _webImage;
  String? _webThumbnail;
  String? _name;
  num? _parentCategoryId;
  num? _id;
  String? _mobileThumbnail;
  num? _categoryId;

  Category copyWith({
    String? mobileImage,
    String? uniqueName,
    String? webImage,
    String? webThumbnail,
    String? name,
    num? parentCategoryId,
    num? id,
    String? mobileThumbnail,
    num? categoryId,
  }) =>
      Category(
        mobileImage: mobileImage ?? _mobileImage,
        uniqueName: uniqueName ?? _uniqueName,
        webImage: webImage ?? _webImage,
        webThumbnail: webThumbnail ?? _webThumbnail,
        name: name ?? _name,
        parentCategoryId: parentCategoryId ?? _parentCategoryId,
        id: id ?? _id,
        mobileThumbnail: mobileThumbnail ?? _mobileThumbnail,
        categoryId: categoryId ?? _categoryId,
      );

  String? get mobileImage => _mobileImage;

  String? get uniqueName => _uniqueName;

  String? get webImage => _webImage;

  String? get webThumbnail => _webThumbnail;

  String? get name => _name;

  num? get parentCategoryId => _parentCategoryId;

  num? get id => _id;

  String? get mobileThumbnail => _mobileThumbnail;

  num? get categoryId => _categoryId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobileImage'] = _mobileImage;
    map['unique_name'] = _uniqueName;
    map['webImage'] = _webImage;
    map['webThumbnail'] = _webThumbnail;
    map['name'] = _name;
    map['parentCategoryId'] = _parentCategoryId;
    map['id'] = _id;
    map['mobileThumbnail'] = _mobileThumbnail;
    map['categoryId'] = _categoryId;
    return map;
  }
}
