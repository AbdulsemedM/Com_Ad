// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WarehouseDeliveryAddressModel {
  final String wareHouseName;
  final String physicalAddress;
  final String? latitude;
  final String? longitude;
  WarehouseDeliveryAddressModel({
    required this.wareHouseName,
    required this.physicalAddress,
    this.latitude,
    this.longitude,
  });

  WarehouseDeliveryAddressModel copyWith({
    String? wareHouseName,
    String? physicalAddress,
    String? latitude,
    String? longitude,
  }) {
    return WarehouseDeliveryAddressModel(
      wareHouseName: wareHouseName ?? this.wareHouseName,
      physicalAddress: physicalAddress ?? this.physicalAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'wareHouseName': wareHouseName,
      'physicalAddress': physicalAddress,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory WarehouseDeliveryAddressModel.fromMap(Map<String, dynamic> map) {
    return WarehouseDeliveryAddressModel(
      wareHouseName: map['wareHouseName'] as String,
      physicalAddress: map['physicalAddress'] as String,
      latitude: map['latitude'] != null ? map['latitude'] as String : null,
      longitude: map['longitude'] != null ? map['longitude'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WarehouseDeliveryAddressModel.fromJson(String source) =>
      WarehouseDeliveryAddressModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WarehouseDeliveryAddressModel(wareHouseName: $wareHouseName, physicalAddress: $physicalAddress, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(covariant WarehouseDeliveryAddressModel other) {
    if (identical(this, other)) return true;

    return other.wareHouseName == wareHouseName &&
        other.physicalAddress == physicalAddress &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return wareHouseName.hashCode ^
        physicalAddress.hashCode ^
        latitude.hashCode ^
        longitude.hashCode;
  }
}
