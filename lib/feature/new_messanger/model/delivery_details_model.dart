// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:commercepal_admin_flutter/feature/new_messanger/model/customer_info_model.dart';
import 'package:commercepal_admin_flutter/feature/new_messanger/model/delivery_address_model.dart';
import 'package:commercepal_admin_flutter/feature/new_messanger/model/item_model.dart';
import 'package:commercepal_admin_flutter/feature/new_messanger/model/warehouse_delivery_address_model.dart';

class DeliveryDetailsModel {
  final int id;
  final String deliveryType;
  final String appName;
  final String? pickingDate;
  final String validationCode;
  final String validationStatus;
  final String deliveryCode;
  final String deliveryStatus;
  final ItemModel itemModel;
  final CustomerInfoModel? customerInfoModel;
  final DeliveryAddressModel deliveryAddressModel;
  final WarehouseDeliveryAddressModel warehouseDeliveryAddressModel;
  DeliveryDetailsModel({
    required this.id,
    required this.deliveryType,
    required this.appName,
    this.pickingDate,
    required this.validationCode,
    required this.validationStatus,
    required this.deliveryCode,
    required this.deliveryStatus,
    required this.itemModel,
    this.customerInfoModel,
    required this.deliveryAddressModel,
    required this.warehouseDeliveryAddressModel,
  });

  DeliveryDetailsModel copyWith({
    int? id,
    String? deliveryType,
    String? appName,
    String? pickingDate,
    String? validationCode,
    String? validationStatus,
    String? deliveryCode,
    String? deliveryStatus,
    ItemModel? itemModel,
    CustomerInfoModel? customerInfoModel,
    DeliveryAddressModel? deliveryAddressModel,
    WarehouseDeliveryAddressModel? warehouseDeliveryAddressModel,
  }) {
    return DeliveryDetailsModel(
      id: id ?? this.id,
      deliveryType: deliveryType ?? this.deliveryType,
      appName: appName ?? this.appName,
      pickingDate: pickingDate ?? this.pickingDate,
      validationCode: validationCode ?? this.validationCode,
      validationStatus: validationStatus ?? this.validationStatus,
      deliveryCode: deliveryCode ?? this.deliveryCode,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      itemModel: itemModel ?? this.itemModel,
      customerInfoModel: customerInfoModel ?? this.customerInfoModel,
      deliveryAddressModel: deliveryAddressModel ?? this.deliveryAddressModel,
      warehouseDeliveryAddressModel: warehouseDeliveryAddressModel ?? this.warehouseDeliveryAddressModel,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'deliveryType': deliveryType,
      'appName': appName,
      'pickingDate': pickingDate,
      'validationCode': validationCode,
      'validationStatus': validationStatus,
      'deliveryCode': deliveryCode,
      'deliveryStatus': deliveryStatus,
      'itemModel': itemModel.toMap(),
      'customerInfoModel': customerInfoModel?.toMap(),
      'deliveryAddressModel': deliveryAddressModel.toMap(),
      'warehouseDeliveryAddressModel': warehouseDeliveryAddressModel.toMap(),
    };
  }

  factory DeliveryDetailsModel.fromMap(Map<String, dynamic> map) {
    return DeliveryDetailsModel(
      id: map['id'] as int,
      deliveryType: map['deliveryType'] as String,
      appName: map['appName'] as String,
      pickingDate: map['pickingDate'] != null ? map['pickingDate'] as String : null,
      validationCode: map['validationCode'] as String,
      validationStatus: map['validationStatus'] as String,
      deliveryCode: map['deliveryCode'] as String,
      deliveryStatus: map['deliveryStatus'] as String,
      itemModel: ItemModel.fromMap(map['itemModel'] as Map<String,dynamic>),
      customerInfoModel: map['customerInfoModel'] != null ? CustomerInfoModel.fromMap(map['customerInfoModel'] as Map<String,dynamic>) : null,
      deliveryAddressModel: DeliveryAddressModel.fromMap(map['deliveryAddressModel'] as Map<String,dynamic>),
      warehouseDeliveryAddressModel: WarehouseDeliveryAddressModel.fromMap(map['warehouseDeliveryAddressModel'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryDetailsModel.fromJson(String source) => DeliveryDetailsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeliveryDetailsModel(id: $id, deliveryType: $deliveryType, appName: $appName, pickingDate: $pickingDate, validationCode: $validationCode, validationStatus: $validationStatus, deliveryCode: $deliveryCode, deliveryStatus: $deliveryStatus, itemModel: $itemModel, customerInfoModel: $customerInfoModel, deliveryAddressModel: $deliveryAddressModel, warehouseDeliveryAddressModel: $warehouseDeliveryAddressModel)';
  }

  @override
  bool operator ==(covariant DeliveryDetailsModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.deliveryType == deliveryType &&
      other.appName == appName &&
      other.pickingDate == pickingDate &&
      other.validationCode == validationCode &&
      other.validationStatus == validationStatus &&
      other.deliveryCode == deliveryCode &&
      other.deliveryStatus == deliveryStatus &&
      other.itemModel == itemModel &&
      other.customerInfoModel == customerInfoModel &&
      other.deliveryAddressModel == deliveryAddressModel &&
      other.warehouseDeliveryAddressModel == warehouseDeliveryAddressModel;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      deliveryType.hashCode ^
      appName.hashCode ^
      pickingDate.hashCode ^
      validationCode.hashCode ^
      validationStatus.hashCode ^
      deliveryCode.hashCode ^
      deliveryStatus.hashCode ^
      itemModel.hashCode ^
      customerInfoModel.hashCode ^
      deliveryAddressModel.hashCode ^
      warehouseDeliveryAddressModel.hashCode;
  }
}
