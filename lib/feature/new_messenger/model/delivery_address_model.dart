// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DeliveryAddressModel {
  final int id;
  final String country;
  final String cityName;
  final String physicalAddress;
  final String? latitude;
  final String? longitude;
  DeliveryAddressModel({
    required this.id,
    required this.country,
    required this.cityName,
    required this.physicalAddress,
    this.latitude,
    this.longitude,
  });

  DeliveryAddressModel copyWith({
    int? id,
    String? country,
    String? cityName,
    String? physicalAddress,
    String? latitude,
    String? longitude,
  }) {
    return DeliveryAddressModel(
      id: id ?? this.id,
      country: country ?? this.country,
      cityName: cityName ?? this.cityName,
      physicalAddress: physicalAddress ?? this.physicalAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'country': country,
      'cityName': cityName,
      'physicalAddress': physicalAddress,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory DeliveryAddressModel.fromMap(Map<String, dynamic> map) {
    return DeliveryAddressModel(
      id: map['id'] as int,
      country: map['country'] as String,
      cityName: map['cityName'] as String,
      physicalAddress: map['physicalAddress'] as String,
      latitude: map['latitude'] != null ? map['latitude'] as String : null,
      longitude: map['longitude'] != null ? map['longitude'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryAddressModel.fromJson(String source) => DeliveryAddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeliveryAddressModel(id: $id, country: $country, cityName: $cityName, physicalAddress: $physicalAddress, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(covariant DeliveryAddressModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.country == country &&
      other.cityName == cityName &&
      other.physicalAddress == physicalAddress &&
      other.latitude == latitude &&
      other.longitude == longitude;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      country.hashCode ^
      cityName.hashCode ^
      physicalAddress.hashCode ^
      latitude.hashCode ^
      longitude.hashCode;
  }
}
