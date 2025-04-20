// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DeliveryItemsModel {
  final int id;
  final String deliveryType;
  final String appName;
  final String assignedDate;
  final String deliveryStatus;
  final String validationStatus;
  DeliveryItemsModel({
    required this.id,
    required this.deliveryType,
    required this.appName,
    required this.assignedDate,
    required this.deliveryStatus,
    required this.validationStatus,
  });

  DeliveryItemsModel copyWith({
    int? id,
    String? deliveryType,
    String? appName,
    String? assignedDate,
    String? deliveryStatus,
    String? validationStatus,
  }) {
    return DeliveryItemsModel(
      id: id ?? this.id,
      deliveryType: deliveryType ?? this.deliveryType,
      appName: appName ?? this.appName,
      assignedDate: assignedDate ?? this.assignedDate,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      validationStatus: validationStatus ?? this.validationStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'deliveryType': deliveryType,
      'appName': appName,
      'assignedDate': assignedDate,
      'deliveryStatus': deliveryStatus,
      'validationStatus': validationStatus,
    };
  }

  factory DeliveryItemsModel.fromMap(Map<String, dynamic> map) {
    return DeliveryItemsModel(
      id: map['id'] as int,
      deliveryType: map['deliveryType'] as String,
      appName: map['appName'] as String,
      assignedDate: map['assignedDate'] as String,
      deliveryStatus: map['deliveryStatus'] as String,
      validationStatus: map['validationStatus'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryItemsModel.fromJson(String source) => DeliveryItemsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeliveryItemsModel(id: $id, deliveryType: $deliveryType, appName: $appName, assignedDate: $assignedDate, deliveryStatus: $deliveryStatus, validationStatus: $validationStatus)';
  }

  @override
  bool operator ==(covariant DeliveryItemsModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.deliveryType == deliveryType &&
      other.appName == appName &&
      other.assignedDate == assignedDate &&
      other.deliveryStatus == deliveryStatus &&
      other.validationStatus == validationStatus;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      deliveryType.hashCode ^
      appName.hashCode ^
      assignedDate.hashCode ^
      deliveryStatus.hashCode ^
      validationStatus.hashCode;
  }
}
