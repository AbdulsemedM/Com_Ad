// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CustomerInfoModel {
  final String fullName;
  final String country;
  final String emailAddress;
  final String phoneNumber;
  CustomerInfoModel({
    required this.fullName,
    required this.country,
    required this.emailAddress,
    required this.phoneNumber,
  });

  CustomerInfoModel copyWith({
    String? fullName,
    String? country,
    String? emailAddress,
    String? phoneNumber,
  }) {
    return CustomerInfoModel(
      fullName: fullName ?? this.fullName,
      country: country ?? this.country,
      emailAddress: emailAddress ?? this.emailAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'country': country,
      'emailAddress': emailAddress,
      'phoneNumber': phoneNumber,
    };
  }

  factory CustomerInfoModel.fromMap(Map<String, dynamic> map) {
    return CustomerInfoModel(
      fullName: map['fullName'] as String,
      country: map['country'] as String,
      emailAddress: map['emailAddress'] as String,
      phoneNumber: map['phoneNumber'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerInfoModel.fromJson(String source) => CustomerInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CustomerInfoModel(fullName: $fullName, country: $country, emailAddress: $emailAddress, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(covariant CustomerInfoModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.fullName == fullName &&
      other.country == country &&
      other.emailAddress == emailAddress &&
      other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^
      country.hashCode ^
      emailAddress.hashCode ^
      phoneNumber.hashCode;
  }
}
