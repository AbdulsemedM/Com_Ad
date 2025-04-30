// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MerchantInfoModel {
  final String merchantId;
  final String ownerPhoneNumber;
  final String businessPhoneNumber;
  final String merchantName;
  final String? district;
  final String? physicalAddress;
  final String? longitude;
  final String? latitude;
  MerchantInfoModel({
    required this.merchantId,
    required this.ownerPhoneNumber,
    required this.businessPhoneNumber,
    required this.merchantName,
    this.district,
    this.physicalAddress,
    this.longitude,
    this.latitude,
  });

  MerchantInfoModel copyWith({
    String? merchantId,
    String? ownerPhoneNumber,
    String? businessPhoneNumber,
    String? merchantName,
    String? district,
    String? physicalAddress,
    String? longitude,
    String? latitude,
  }) {
    return MerchantInfoModel(
      merchantId: merchantId ?? this.merchantId,
      ownerPhoneNumber: ownerPhoneNumber ?? this.ownerPhoneNumber,
      businessPhoneNumber: businessPhoneNumber ?? this.businessPhoneNumber,
      merchantName: merchantName ?? this.merchantName,
      district: district ?? this.district,
      physicalAddress: physicalAddress ?? this.physicalAddress,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'merchantId': merchantId,
      'ownerPhoneNumber': ownerPhoneNumber,
      'businessPhoneNumber': businessPhoneNumber,
      'merchantName': merchantName,
      'district': district,
      'physicalAddress': physicalAddress,
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  factory MerchantInfoModel.fromMap(Map<String, dynamic> map) {
    return MerchantInfoModel(
      merchantId: map['merchantId'] as String,
      ownerPhoneNumber: map['ownerPhoneNumber'] as String,
      businessPhoneNumber: map['businessPhoneNumber'] as String,
      merchantName: map['merchantName'] as String,
      district: map['district'] != null ? map['district'] as String : null,
      physicalAddress: map['physicalAddress'] != null
          ? map['physicalAddress'] as String
          : null,
      longitude: map['longitude'] != null ? map['longitude'] as String : null,
      latitude: map['latitude'] != null ? map['latitude'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MerchantInfoModel.fromJson(String source) =>
      MerchantInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MerchantInfoModel(merchantId: $merchantId, ownerPhoneNumber: $ownerPhoneNumber, businessPhoneNumber: $businessPhoneNumber, merchantName: $merchantName, district: $district, physicalAddress: $physicalAddress, longitude: $longitude, latitude: $latitude)';
  }

  @override
  bool operator ==(covariant MerchantInfoModel other) {
    if (identical(this, other)) return true;

    return other.merchantId == merchantId &&
        other.ownerPhoneNumber == ownerPhoneNumber &&
        other.businessPhoneNumber == businessPhoneNumber &&
        other.merchantName == merchantName &&
        other.district == district &&
        other.physicalAddress == physicalAddress &&
        other.longitude == longitude &&
        other.latitude == latitude;
  }

  @override
  int get hashCode {
    return merchantId.hashCode ^
        ownerPhoneNumber.hashCode ^
        businessPhoneNumber.hashCode ^
        merchantName.hashCode ^
        district.hashCode ^
        physicalAddress.hashCode ^
        longitude.hashCode ^
        latitude.hashCode;
  }
}
