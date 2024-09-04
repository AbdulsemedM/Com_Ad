import 'dart:convert';

import '../../domain/models/category.dart';

/// statusDescription : "success"
/// data : [{"mobileImage":"","unique_name":"mobile_phones","webImage":"","webThumbnail":"https://commercepal.s3.af-south-1.amazonaws.com/WebThumbnail/Images/category_1668091712639_271.png","name":"Mobile Phones","parentCategoryId":1,"id":1,"mobileThumbnail":"https://commercepal.s3.af-south-1.amazonaws.com/MobileThumbnail/Images/Category_1684915827026_357.jpg","categoryId":1}]
/// statusMessage : "Request Successful"
/// statusCode : "000"

CategoryResponseDto categoryResponseDtoFromJson(String str) =>
    CategoryResponseDto.fromJson(json.decode(str));

String categoryResponseDtoToJson(CategoryResponseDto data) =>
    json.encode(data.toJson());

class CategoryResponseDto {
  CategoryResponseDto({
    String? statusDescription,
    List<Category>? data,
    String? statusMessage,
    String? statusCode,
  }) {
    _statusDescription = statusDescription;
    _data = data;
    _statusMessage = statusMessage;
    _statusCode = statusCode;
  }

  CategoryResponseDto.fromJson(dynamic json) {
    _statusDescription = json['statusDescription'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Category.fromJson(v));
      });
    }
    if (json['details'] != null) {
      _data = [];
      json['details'].forEach((v) {
        _data?.add(Category.fromJson(v));
      });
    }
    _statusMessage = json['statusMessage'];
    _statusCode = json['statusCode'];
  }

  String? _statusDescription;
  List<Category>? _data;
  String? _statusMessage;
  String? _statusCode;

  CategoryResponseDto copyWith({
    String? statusDescription,
    List<Category>? data,
    String? statusMessage,
    String? statusCode,
  }) =>
      CategoryResponseDto(
        statusDescription: statusDescription ?? _statusDescription,
        data: data ?? _data,
        statusMessage: statusMessage ?? _statusMessage,
        statusCode: statusCode ?? _statusCode,
      );

  String? get statusDescription => _statusDescription;

  List<Category>? get data => _data;

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
