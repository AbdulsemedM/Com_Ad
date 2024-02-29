import 'dart:convert';

/// IsDistributor : "YES"
/// IsBusiness : "YES"
/// IsMessenger : "YES"
/// merchantInfo : {"ownerType":"DISTRIBUTOR","businessLicense":"0","ownerPhoneNumber":"251911679409","country":"ET","lastName":"hassen","city":1,"latitude":"0","language":"en","branch":"0","commercialCertNo":"0","bankAccountNumber":"0","email":"ame305a@gmail.com","longitude":"0","Status":"1","bankCode":"104","tillNumber":"1000656","commissionAccount":"10006561","taxNumber":"0","userId":672,"firstName":"amin","phoneNumber":"251911679409","termOfService":0,"name":"251911679409","businessCategory":"1","businessType":"shop"}
/// statusMessage : "success"
/// businessInfo : {"ownerType":"WAREHOUSE","businessLicense":"SM/JKC03/05/234125/6998422/2914","ownerPhoneNumber":"251919175141","country":"ET","lastName":"hassen","city":2,"latitude":"0","language":"en","BusinessRegistrationPhoto":"https://commercepal.s3.af-south-1.amazonaws.com/Web/BUSINESS/BUSINESS_1663163456854_733.png","commercialCertNo":"SM/JKC03/05/234125/6998422/2914","TaxPhoto":"https://commercepal.s3.af-south-1.amazonaws.com/Web/BUSINESS/BUSINESS_1663163444627_199.png","email":"ame305a@gmail.com","longitude":"0","businessSector":6,"Status":"0","TillNumberImage":"https://commercepal.s3.af-south-1.amazonaws.com/Web/BUSINESS/BUSINESS_1663163444205_371.png","tillNumber":"2001009","userId":2177,"OwnerPhoto":"https://commercepal.s3.af-south-1.amazonaws.com/Web/BUSINESS/BUSINESS_1663163422621_184.png","ShopImage":"https://commercepal.s3.af-south-1.amazonaws.com/Web/BUSINESS/BUSINESS_1663163461963_115.jpg","firstName":"amin","phoneNumber":"251911679409","CommercialCertImage":"https://commercepal.s3.af-south-1.amazonaws.com/Web/BUSINESS/BUSINESS_1663163440476_111.png","termOfService":0,"name":"abay hasan jama","businessPhoneNumber":"251919175141"}
/// statusDescription : "success"
/// Details : {"firstName":"amin","lastName":"hassen","country":"ET","phoneNumber":"251911679409","oneSignalToken":"d2314b68-b9e2-4e30-b7c2-3608166cb5ab","city":"3","district":"09","language":"en","location":"Bulbula","userId":1336,"email":"ame305a@gmail.com"}
/// IsAgent : "NO"
/// distributorInfo : {"Status":"0","ownerPhoneNumber":"251911679409","country":"ET","lastName":"hassen","city":"1","canRegBusiness":1,"distributorType":"B|M|A","latitude":"0","canRegAgent":1,"language":"en","idNumber":"251911679409","userId":114,"branch":"Addis Ababa","distributorName":"eshop","firstName":"amin","canRegMerchant":1,"phoneNumber":"251911679409","name":"eshop","email":"ame305a@gmail.com","businessPhoneNumber":"251911679409","longitude":"0"}
/// IsMerchant : "YES"
/// messengerInfo : {"ownerType":"WAREHOUSE","Status":"0","ownerPhoneNumber":"251911679409","country":"ET","lastName":"hassen","nextOfKin":{},"city":"1","latitude":"12.34635634","carrierType":"251911679409","language":"en","idNumber":"251911679409","userId":9,"insuranceExpiry":"12/5/2022, 12:00:00 AM","firstName":"amin","phoneNumber":"251911679409","carrierLicencePlate":"251911679409","district":"251911679409","location":"251911679409","email":"ame305a@gmail.com","drivingLicenceNumber":"251911679409","longitude":"32.131523"}
/// statusCode : "000"

User userResponseDtoFromJson(String str) =>
    User.fromJson(json.decode(str));

String userResponseDtoToJson(User data) =>
    json.encode(data.toJson());

class User {
  User({
    String? isDistributor,
    String? isBusiness,
    String? isMessenger,
    MerchantInfo? merchantInfo,
    String? statusMessage,
    BusinessInfo? businessInfo,
    String? statusDescription,
    Details? details,
    String? isAgent,
    DistributorInfo? distributorInfo,
    String? isMerchant,
    MessengerInfo? messengerInfo,
    String? statusCode,
  }) {
    _isDistributor = isDistributor;
    _isBusiness = isBusiness;
    _isMessenger = isMessenger;
    _merchantInfo = merchantInfo;
    _statusMessage = statusMessage;
    _businessInfo = businessInfo;
    _statusDescription = statusDescription;
    _details = details;
    _isAgent = isAgent;
    _distributorInfo = distributorInfo;
    _isMerchant = isMerchant;
    _messengerInfo = messengerInfo;
    _statusCode = statusCode;
  }

  User.fromJson(dynamic json) {
    _isDistributor = json['IsDistributor'];
    _isBusiness = json['IsBusiness'];
    _isMessenger = json['IsMessenger'];
    _merchantInfo = json['merchantInfo'] != null
        ? MerchantInfo.fromJson(json['merchantInfo'])
        : null;
    _statusMessage = json['statusMessage'];
    _businessInfo = json['businessInfo'] != null
        ? BusinessInfo.fromJson(json['businessInfo'])
        : null;
    _statusDescription = json['statusDescription'];
    _details =
    json['Details'] != null ? Details.fromJson(json['Details']) : null;
    _isAgent = json['IsAgent'];
    _distributorInfo = json['distributorInfo'] != null
        ? DistributorInfo.fromJson(json['distributorInfo'])
        : null;
    _isMerchant = json['IsMerchant'];
    _messengerInfo = json['messengerInfo'] != null
        ? MessengerInfo.fromJson(json['messengerInfo'])
        : null;
    _statusCode = json['statusCode'];
  }

  String? _isDistributor;
  String? _isBusiness;
  String? _isMessenger;
  MerchantInfo? _merchantInfo;
  String? _statusMessage;
  BusinessInfo? _businessInfo;
  String? _statusDescription;
  Details? _details;
  String? _isAgent;
  DistributorInfo? _distributorInfo;
  String? _isMerchant;
  MessengerInfo? _messengerInfo;
  String? _statusCode;

  User copyWith({
    String? isDistributor,
    String? isBusiness,
    String? isMessenger,
    MerchantInfo? merchantInfo,
    String? statusMessage,
    BusinessInfo? businessInfo,
    String? statusDescription,
    Details? details,
    String? isAgent,
    DistributorInfo? distributorInfo,
    String? isMerchant,
    MessengerInfo? messengerInfo,
    String? statusCode,
  }) =>
      User(
        isDistributor: isDistributor ?? _isDistributor,
        isBusiness: isBusiness ?? _isBusiness,
        isMessenger: isMessenger ?? _isMessenger,
        merchantInfo: merchantInfo ?? _merchantInfo,
        statusMessage: statusMessage ?? _statusMessage,
        businessInfo: businessInfo ?? _businessInfo,
        statusDescription: statusDescription ?? _statusDescription,
        details: details ?? _details,
        isAgent: isAgent ?? _isAgent,
        distributorInfo: distributorInfo ?? _distributorInfo,
        isMerchant: isMerchant ?? _isMerchant,
        messengerInfo: messengerInfo ?? _messengerInfo,
        statusCode: statusCode ?? _statusCode,
      );

  String? get isDistributor => _isDistributor;

  String? get isBusiness => _isBusiness;

  String? get isMessenger => _isMessenger;

  MerchantInfo? get merchantInfo => _merchantInfo;

  String? get statusMessage => _statusMessage;

  BusinessInfo? get businessInfo => _businessInfo;

  String? get statusDescription => _statusDescription;

  Details? get details => _details;

  String? get isAgent => _isAgent;

  DistributorInfo? get distributorInfo => _distributorInfo;

  String? get isMerchant => _isMerchant;

  MessengerInfo? get messengerInfo => _messengerInfo;

  String? get statusCode => _statusCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['IsDistributor'] = _isDistributor;
    map['IsBusiness'] = _isBusiness;
    map['IsMessenger'] = _isMessenger;
    if (_merchantInfo != null) {
      map['merchantInfo'] = _merchantInfo?.toJson();
    }
    map['statusMessage'] = _statusMessage;
    if (_businessInfo != null) {
      map['businessInfo'] = _businessInfo?.toJson();
    }
    map['statusDescription'] = _statusDescription;
    if (_details != null) {
      map['Details'] = _details?.toJson();
    }
    map['IsAgent'] = _isAgent;
    if (_distributorInfo != null) {
      map['distributorInfo'] = _distributorInfo?.toJson();
    }
    map['IsMerchant'] = _isMerchant;
    if (_messengerInfo != null) {
      map['messengerInfo'] = _messengerInfo?.toJson();
    }
    map['statusCode'] = _statusCode;
    return map;
  }
}

/// ownerType : "WAREHOUSE"
/// Status : "0"
/// ownerPhoneNumber : "251911679409"
/// country : "ET"
/// lastName : "hassen"
/// nextOfKin : {}
/// city : "1"
/// latitude : "12.34635634"
/// carrierType : "251911679409"
/// language : "en"
/// idNumber : "251911679409"
/// userId : 9
/// insuranceExpiry : "12/5/2022, 12:00:00 AM"
/// firstName : "amin"
/// phoneNumber : "251911679409"
/// carrierLicencePlate : "251911679409"
/// district : "251911679409"
/// location : "251911679409"
/// email : "ame305a@gmail.com"
/// drivingLicenceNumber : "251911679409"
/// longitude : "32.131523"

MessengerInfo messengerInfoFromJson(String str) =>
    MessengerInfo.fromJson(json.decode(str));

String messengerInfoToJson(MessengerInfo data) => json.encode(data.toJson());

class MessengerInfo {
  MessengerInfo({
    String? ownerType,
    String? status,
    String? ownerPhoneNumber,
    String? country,
    String? lastName,
    dynamic nextOfKin,
    String? city,
    String? latitude,
    String? carrierType,
    String? language,
    String? idNumber,
    num? userId,
    String? insuranceExpiry,
    String? firstName,
    String? phoneNumber,
    String? carrierLicencePlate,
    String? district,
    String? location,
    String? email,
    String? drivingLicenceNumber,
    String? longitude,
  }) {
    _ownerType = ownerType;
    _status = status;
    _ownerPhoneNumber = ownerPhoneNumber;
    _country = country;
    _lastName = lastName;
    _nextOfKin = nextOfKin;
    _city = city;
    _latitude = latitude;
    _carrierType = carrierType;
    _language = language;
    _idNumber = idNumber;
    _userId = userId;
    _insuranceExpiry = insuranceExpiry;
    _firstName = firstName;
    _phoneNumber = phoneNumber;
    _carrierLicencePlate = carrierLicencePlate;
    _district = district;
    _location = location;
    _email = email;
    _drivingLicenceNumber = drivingLicenceNumber;
    _longitude = longitude;
  }

  MessengerInfo.fromJson(dynamic json) {
    _ownerType = json['ownerType'];
    _status = json['Status'];
    _ownerPhoneNumber = json['ownerPhoneNumber'];
    _country = json['country'];
    _lastName = json['lastName'];
    _nextOfKin = json['nextOfKin'];
    _city = json['city'];
    _latitude = json['latitude'];
    _carrierType = json['carrierType'];
    _language = json['language'];
    _idNumber = json['idNumber'];
    _userId = json['userId'];
    _insuranceExpiry = json['insuranceExpiry'];
    _firstName = json['firstName'];
    _phoneNumber = json['phoneNumber'];
    _carrierLicencePlate = json['carrierLicencePlate'];
    _district = json['district'];
    _location = json['location'];
    _email = json['email'];
    _drivingLicenceNumber = json['drivingLicenceNumber'];
    _longitude = json['longitude'];
  }

  String? _ownerType;
  String? _status;
  String? _ownerPhoneNumber;
  String? _country;
  String? _lastName;
  dynamic _nextOfKin;
  String? _city;
  String? _latitude;
  String? _carrierType;
  String? _language;
  String? _idNumber;
  num? _userId;
  String? _insuranceExpiry;
  String? _firstName;
  String? _phoneNumber;
  String? _carrierLicencePlate;
  String? _district;
  String? _location;
  String? _email;
  String? _drivingLicenceNumber;
  String? _longitude;

  MessengerInfo copyWith({
    String? ownerType,
    String? status,
    String? ownerPhoneNumber,
    String? country,
    String? lastName,
    dynamic nextOfKin,
    String? city,
    String? latitude,
    String? carrierType,
    String? language,
    String? idNumber,
    num? userId,
    String? insuranceExpiry,
    String? firstName,
    String? phoneNumber,
    String? carrierLicencePlate,
    String? district,
    String? location,
    String? email,
    String? drivingLicenceNumber,
    String? longitude,
  }) =>
      MessengerInfo(
        ownerType: ownerType ?? _ownerType,
        status: status ?? _status,
        ownerPhoneNumber: ownerPhoneNumber ?? _ownerPhoneNumber,
        country: country ?? _country,
        lastName: lastName ?? _lastName,
        nextOfKin: nextOfKin ?? _nextOfKin,
        city: city ?? _city,
        latitude: latitude ?? _latitude,
        carrierType: carrierType ?? _carrierType,
        language: language ?? _language,
        idNumber: idNumber ?? _idNumber,
        userId: userId ?? _userId,
        insuranceExpiry: insuranceExpiry ?? _insuranceExpiry,
        firstName: firstName ?? _firstName,
        phoneNumber: phoneNumber ?? _phoneNumber,
        carrierLicencePlate: carrierLicencePlate ?? _carrierLicencePlate,
        district: district ?? _district,
        location: location ?? _location,
        email: email ?? _email,
        drivingLicenceNumber: drivingLicenceNumber ?? _drivingLicenceNumber,
        longitude: longitude ?? _longitude,
      );

  String? get ownerType => _ownerType;

  String? get status => _status;

  String? get ownerPhoneNumber => _ownerPhoneNumber;

  String? get country => _country;

  String? get lastName => _lastName;

  dynamic get nextOfKin => _nextOfKin;

  String? get city => _city;

  String? get latitude => _latitude;

  String? get carrierType => _carrierType;

  String? get language => _language;

  String? get idNumber => _idNumber;

  num? get userId => _userId;

  String? get insuranceExpiry => _insuranceExpiry;

  String? get firstName => _firstName;

  String? get phoneNumber => _phoneNumber;

  String? get carrierLicencePlate => _carrierLicencePlate;

  String? get district => _district;

  String? get location => _location;

  String? get email => _email;

  String? get drivingLicenceNumber => _drivingLicenceNumber;

  String? get longitude => _longitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ownerType'] = _ownerType;
    map['Status'] = _status;
    map['ownerPhoneNumber'] = _ownerPhoneNumber;
    map['country'] = _country;
    map['lastName'] = _lastName;
    map['nextOfKin'] = _nextOfKin;
    map['city'] = _city;
    map['latitude'] = _latitude;
    map['carrierType'] = _carrierType;
    map['language'] = _language;
    map['idNumber'] = _idNumber;
    map['userId'] = _userId;
    map['insuranceExpiry'] = _insuranceExpiry;
    map['firstName'] = _firstName;
    map['phoneNumber'] = _phoneNumber;
    map['carrierLicencePlate'] = _carrierLicencePlate;
    map['district'] = _district;
    map['location'] = _location;
    map['email'] = _email;
    map['drivingLicenceNumber'] = _drivingLicenceNumber;
    map['longitude'] = _longitude;
    return map;
  }
}

/// Status : "0"
/// ownerPhoneNumber : "251911679409"
/// country : "ET"
/// lastName : "hassen"
/// city : "1"
/// canRegBusiness : 1
/// distributorType : "B|M|A"
/// latitude : "0"
/// canRegAgent : 1
/// language : "en"
/// idNumber : "251911679409"
/// userId : 114
/// branch : "Addis Ababa"
/// distributorName : "eshop"
/// firstName : "amin"
/// canRegMerchant : 1
/// phoneNumber : "251911679409"
/// name : "eshop"
/// email : "ame305a@gmail.com"
/// businessPhoneNumber : "251911679409"
/// longitude : "0"

DistributorInfo distributorInfoFromJson(String str) =>
    DistributorInfo.fromJson(json.decode(str));

String distributorInfoToJson(DistributorInfo data) =>
    json.encode(data.toJson());

class DistributorInfo {
  DistributorInfo({
    String? status,
    String? ownerPhoneNumber,
    String? country,
    String? lastName,
    String? city,
    num? canRegBusiness,
    String? distributorType,
    String? latitude,
    num? canRegAgent,
    String? language,
    String? idNumber,
    num? userId,
    String? branch,
    String? distributorName,
    String? firstName,
    num? canRegMerchant,
    String? phoneNumber,
    String? name,
    String? email,
    String? businessPhoneNumber,
    String? longitude,
  }) {
    _status = status;
    _ownerPhoneNumber = ownerPhoneNumber;
    _country = country;
    _lastName = lastName;
    _city = city;
    _canRegBusiness = canRegBusiness;
    _distributorType = distributorType;
    _latitude = latitude;
    _canRegAgent = canRegAgent;
    _language = language;
    _idNumber = idNumber;
    _userId = userId;
    _branch = branch;
    _distributorName = distributorName;
    _firstName = firstName;
    _canRegMerchant = canRegMerchant;
    _phoneNumber = phoneNumber;
    _name = name;
    _email = email;
    _businessPhoneNumber = businessPhoneNumber;
    _longitude = longitude;
  }

  DistributorInfo.fromJson(dynamic json) {
    _status = json['Status'];
    _ownerPhoneNumber = json['ownerPhoneNumber'];
    _country = json['country'];
    _lastName = json['lastName'];
    _city = json['city'];
    _canRegBusiness = json['canRegBusiness'];
    _distributorType = json['distributorType'];
    _latitude = json['latitude'];
    _canRegAgent = json['canRegAgent'];
    _language = json['language'];
    _idNumber = json['idNumber'];
    _userId = json['userId'];
    _branch = json['branch'];
    _distributorName = json['distributorName'];
    _firstName = json['firstName'];
    _canRegMerchant = json['canRegMerchant'];
    _phoneNumber = json['phoneNumber'];
    _name = json['name'];
    _email = json['email'];
    _businessPhoneNumber = json['businessPhoneNumber'];
    _longitude = json['longitude'];
  }

  String? _status;
  String? _ownerPhoneNumber;
  String? _country;
  String? _lastName;
  String? _city;
  num? _canRegBusiness;
  String? _distributorType;
  String? _latitude;
  num? _canRegAgent;
  String? _language;
  String? _idNumber;
  num? _userId;
  String? _branch;
  String? _distributorName;
  String? _firstName;
  num? _canRegMerchant;
  String? _phoneNumber;
  String? _name;
  String? _email;
  String? _businessPhoneNumber;
  String? _longitude;

  DistributorInfo copyWith({
    String? status,
    String? ownerPhoneNumber,
    String? country,
    String? lastName,
    String? city,
    num? canRegBusiness,
    String? distributorType,
    String? latitude,
    num? canRegAgent,
    String? language,
    String? idNumber,
    num? userId,
    String? branch,
    String? distributorName,
    String? firstName,
    num? canRegMerchant,
    String? phoneNumber,
    String? name,
    String? email,
    String? businessPhoneNumber,
    String? longitude,
  }) =>
      DistributorInfo(
        status: status ?? _status,
        ownerPhoneNumber: ownerPhoneNumber ?? _ownerPhoneNumber,
        country: country ?? _country,
        lastName: lastName ?? _lastName,
        city: city ?? _city,
        canRegBusiness: canRegBusiness ?? _canRegBusiness,
        distributorType: distributorType ?? _distributorType,
        latitude: latitude ?? _latitude,
        canRegAgent: canRegAgent ?? _canRegAgent,
        language: language ?? _language,
        idNumber: idNumber ?? _idNumber,
        userId: userId ?? _userId,
        branch: branch ?? _branch,
        distributorName: distributorName ?? _distributorName,
        firstName: firstName ?? _firstName,
        canRegMerchant: canRegMerchant ?? _canRegMerchant,
        phoneNumber: phoneNumber ?? _phoneNumber,
        name: name ?? _name,
        email: email ?? _email,
        businessPhoneNumber: businessPhoneNumber ?? _businessPhoneNumber,
        longitude: longitude ?? _longitude,
      );

  String? get status => _status;

  String? get ownerPhoneNumber => _ownerPhoneNumber;

  String? get country => _country;

  String? get lastName => _lastName;

  String? get city => _city;

  num? get canRegBusiness => _canRegBusiness;

  String? get distributorType => _distributorType;

  String? get latitude => _latitude;

  num? get canRegAgent => _canRegAgent;

  String? get language => _language;

  String? get idNumber => _idNumber;

  num? get userId => _userId;

  String? get branch => _branch;

  String? get distributorName => _distributorName;

  String? get firstName => _firstName;

  num? get canRegMerchant => _canRegMerchant;

  String? get phoneNumber => _phoneNumber;

  String? get name => _name;

  String? get email => _email;

  String? get businessPhoneNumber => _businessPhoneNumber;

  String? get longitude => _longitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Status'] = _status;
    map['ownerPhoneNumber'] = _ownerPhoneNumber;
    map['country'] = _country;
    map['lastName'] = _lastName;
    map['city'] = _city;
    map['canRegBusiness'] = _canRegBusiness;
    map['distributorType'] = _distributorType;
    map['latitude'] = _latitude;
    map['canRegAgent'] = _canRegAgent;
    map['language'] = _language;
    map['idNumber'] = _idNumber;
    map['userId'] = _userId;
    map['branch'] = _branch;
    map['distributorName'] = _distributorName;
    map['firstName'] = _firstName;
    map['canRegMerchant'] = _canRegMerchant;
    map['phoneNumber'] = _phoneNumber;
    map['name'] = _name;
    map['email'] = _email;
    map['businessPhoneNumber'] = _businessPhoneNumber;
    map['longitude'] = _longitude;
    return map;
  }
}

/// firstName : "amin"
/// lastName : "hassen"
/// country : "ET"
/// phoneNumber : "251911679409"
/// oneSignalToken : "d2314b68-b9e2-4e30-b7c2-3608166cb5ab"
/// city : "3"
/// district : "09"
/// language : "en"
/// location : "Bulbula"
/// userId : 1336
/// email : "ame305a@gmail.com"

Details detailsFromJson(String str) => Details.fromJson(json.decode(str));

String detailsToJson(Details data) => json.encode(data.toJson());

class Details {
  Details({
    String? firstName,
    String? lastName,
    String? country,
    String? phoneNumber,
    String? oneSignalToken,
    String? city,
    String? district,
    String? language,
    String? location,
    num? userId,
    String? email,
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _country = country;
    _phoneNumber = phoneNumber;
    _oneSignalToken = oneSignalToken;
    _city = city;
    _district = district;
    _language = language;
    _location = location;
    _userId = userId;
    _email = email;
  }

  Details.fromJson(dynamic json) {
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _country = json['country'];
    _phoneNumber = json['phoneNumber'];
    _oneSignalToken = json['oneSignalToken'];
    _city = json['city'];
    _district = json['district'];
    _language = json['language'];
    _location = json['location'];
    _userId = json['userId'];
    _email = json['email'];
  }

  String? _firstName;
  String? _lastName;
  String? _country;
  String? _phoneNumber;
  String? _oneSignalToken;
  String? _city;
  String? _district;
  String? _language;
  String? _location;
  num? _userId;
  String? _email;

  Details copyWith({
    String? firstName,
    String? lastName,
    String? country,
    String? phoneNumber,
    String? oneSignalToken,
    String? city,
    String? district,
    String? language,
    String? location,
    num? userId,
    String? email,
  }) =>
      Details(
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        country: country ?? _country,
        phoneNumber: phoneNumber ?? _phoneNumber,
        oneSignalToken: oneSignalToken ?? _oneSignalToken,
        city: city ?? _city,
        district: district ?? _district,
        language: language ?? _language,
        location: location ?? _location,
        userId: userId ?? _userId,
        email: email ?? _email,
      );

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get country => _country;

  String? get phoneNumber => _phoneNumber;

  String? get oneSignalToken => _oneSignalToken;

  String? get city => _city;

  String? get district => _district;

  String? get language => _language;

  String? get location => _location;

  num? get userId => _userId;

  String? get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['country'] = _country;
    map['phoneNumber'] = _phoneNumber;
    map['oneSignalToken'] = _oneSignalToken;
    map['city'] = _city;
    map['district'] = _district;
    map['language'] = _language;
    map['location'] = _location;
    map['userId'] = _userId;
    map['email'] = _email;
    return map;
  }
}

/// ownerType : "WAREHOUSE"
/// businessLicense : "SM/JKC03/05/234125/6998422/2914"
/// ownerPhoneNumber : "251919175141"
/// country : "ET"
/// lastName : "hassen"
/// city : 2
/// latitude : "0"
/// language : "en"
/// BusinessRegistrationPhoto : "https://commercepal.s3.af-south-1.amazonaws.com/Web/BUSINESS/BUSINESS_1663163456854_733.png"
/// commercialCertNo : "SM/JKC03/05/234125/6998422/2914"
/// TaxPhoto : "https://commercepal.s3.af-south-1.amazonaws.com/Web/BUSINESS/BUSINESS_1663163444627_199.png"
/// email : "ame305a@gmail.com"
/// longitude : "0"
/// businessSector : 6
/// Status : "0"
/// TillNumberImage : "https://commercepal.s3.af-south-1.amazonaws.com/Web/BUSINESS/BUSINESS_1663163444205_371.png"
/// tillNumber : "2001009"
/// userId : 2177
/// OwnerPhoto : "https://commercepal.s3.af-south-1.amazonaws.com/Web/BUSINESS/BUSINESS_1663163422621_184.png"
/// ShopImage : "https://commercepal.s3.af-south-1.amazonaws.com/Web/BUSINESS/BUSINESS_1663163461963_115.jpg"
/// firstName : "amin"
/// phoneNumber : "251911679409"
/// CommercialCertImage : "https://commercepal.s3.af-south-1.amazonaws.com/Web/BUSINESS/BUSINESS_1663163440476_111.png"
/// termOfService : 0
/// name : "abay hasan jama"
/// businessPhoneNumber : "251919175141"

BusinessInfo businessInfoFromJson(String str) =>
    BusinessInfo.fromJson(json.decode(str));

String businessInfoToJson(BusinessInfo data) => json.encode(data.toJson());

class BusinessInfo {
  BusinessInfo({
    String? ownerType,
    String? businessLicense,
    String? ownerPhoneNumber,
    String? country,
    String? lastName,
    num? city,
    String? latitude,
    String? language,
    String? businessRegistrationPhoto,
    String? commercialCertNo,
    String? taxPhoto,
    String? email,
    String? longitude,
    num? businessSector,
    String? status,
    String? tillNumberImage,
    String? tillNumber,
    num? userId,
    String? ownerPhoto,
    String? shopImage,
    String? firstName,
    String? phoneNumber,
    String? commercialCertImage,
    num? termOfService,
    String? name,
    String? businessPhoneNumber,
  }) {
    _ownerType = ownerType;
    _businessLicense = businessLicense;
    _ownerPhoneNumber = ownerPhoneNumber;
    _country = country;
    _lastName = lastName;
    _city = city;
    _latitude = latitude;
    _language = language;
    _businessRegistrationPhoto = businessRegistrationPhoto;
    _commercialCertNo = commercialCertNo;
    _taxPhoto = taxPhoto;
    _email = email;
    _longitude = longitude;
    _businessSector = businessSector;
    _status = status;
    _tillNumberImage = tillNumberImage;
    _tillNumber = tillNumber;
    _userId = userId;
    _ownerPhoto = ownerPhoto;
    _shopImage = shopImage;
    _firstName = firstName;
    _phoneNumber = phoneNumber;
    _commercialCertImage = commercialCertImage;
    _termOfService = termOfService;
    _name = name;
    _businessPhoneNumber = businessPhoneNumber;
  }

  BusinessInfo.fromJson(dynamic json) {
    _ownerType = json['ownerType'];
    _businessLicense = json['businessLicense'];
    _ownerPhoneNumber = json['ownerPhoneNumber'];
    _country = json['country'];
    _lastName = json['lastName'];
    _city = json['city'];
    _latitude = json['latitude'];
    _language = json['language'];
    _businessRegistrationPhoto = json['BusinessRegistrationPhoto'];
    _commercialCertNo = json['commercialCertNo'];
    _taxPhoto = json['TaxPhoto'];
    _email = json['email'];
    _longitude = json['longitude'];
    _businessSector = json['businessSector'];
    _status = json['Status'];
    _tillNumberImage = json['TillNumberImage'];
    _tillNumber = json['tillNumber'];
    _userId = json['userId'];
    _ownerPhoto = json['OwnerPhoto'];
    _shopImage = json['ShopImage'];
    _firstName = json['firstName'];
    _phoneNumber = json['phoneNumber'];
    _commercialCertImage = json['CommercialCertImage'];
    _termOfService = json['termOfService'];
    _name = json['name'];
    _businessPhoneNumber = json['businessPhoneNumber'];
  }

  String? _ownerType;
  String? _businessLicense;
  String? _ownerPhoneNumber;
  String? _country;
  String? _lastName;
  num? _city;
  String? _latitude;
  String? _language;
  String? _businessRegistrationPhoto;
  String? _commercialCertNo;
  String? _taxPhoto;
  String? _email;
  String? _longitude;
  num? _businessSector;
  String? _status;
  String? _tillNumberImage;
  String? _tillNumber;
  num? _userId;
  String? _ownerPhoto;
  String? _shopImage;
  String? _firstName;
  String? _phoneNumber;
  String? _commercialCertImage;
  num? _termOfService;
  String? _name;
  String? _businessPhoneNumber;

  BusinessInfo copyWith({
    String? ownerType,
    String? businessLicense,
    String? ownerPhoneNumber,
    String? country,
    String? lastName,
    num? city,
    String? latitude,
    String? language,
    String? businessRegistrationPhoto,
    String? commercialCertNo,
    String? taxPhoto,
    String? email,
    String? longitude,
    num? businessSector,
    String? status,
    String? tillNumberImage,
    String? tillNumber,
    num? userId,
    String? ownerPhoto,
    String? shopImage,
    String? firstName,
    String? phoneNumber,
    String? commercialCertImage,
    num? termOfService,
    String? name,
    String? businessPhoneNumber,
  }) =>
      BusinessInfo(
        ownerType: ownerType ?? _ownerType,
        businessLicense: businessLicense ?? _businessLicense,
        ownerPhoneNumber: ownerPhoneNumber ?? _ownerPhoneNumber,
        country: country ?? _country,
        lastName: lastName ?? _lastName,
        city: city ?? _city,
        latitude: latitude ?? _latitude,
        language: language ?? _language,
        businessRegistrationPhoto:
        businessRegistrationPhoto ?? _businessRegistrationPhoto,
        commercialCertNo: commercialCertNo ?? _commercialCertNo,
        taxPhoto: taxPhoto ?? _taxPhoto,
        email: email ?? _email,
        longitude: longitude ?? _longitude,
        businessSector: businessSector ?? _businessSector,
        status: status ?? _status,
        tillNumberImage: tillNumberImage ?? _tillNumberImage,
        tillNumber: tillNumber ?? _tillNumber,
        userId: userId ?? _userId,
        ownerPhoto: ownerPhoto ?? _ownerPhoto,
        shopImage: shopImage ?? _shopImage,
        firstName: firstName ?? _firstName,
        phoneNumber: phoneNumber ?? _phoneNumber,
        commercialCertImage: commercialCertImage ?? _commercialCertImage,
        termOfService: termOfService ?? _termOfService,
        name: name ?? _name,
        businessPhoneNumber: businessPhoneNumber ?? _businessPhoneNumber,
      );

  String? get ownerType => _ownerType;

  String? get businessLicense => _businessLicense;

  String? get ownerPhoneNumber => _ownerPhoneNumber;

  String? get country => _country;

  String? get lastName => _lastName;

  num? get city => _city;

  String? get latitude => _latitude;

  String? get language => _language;

  String? get businessRegistrationPhoto => _businessRegistrationPhoto;

  String? get commercialCertNo => _commercialCertNo;

  String? get taxPhoto => _taxPhoto;

  String? get email => _email;

  String? get longitude => _longitude;

  num? get businessSector => _businessSector;

  String? get status => _status;

  String? get tillNumberImage => _tillNumberImage;

  String? get tillNumber => _tillNumber;

  num? get userId => _userId;

  String? get ownerPhoto => _ownerPhoto;

  String? get shopImage => _shopImage;

  String? get firstName => _firstName;

  String? get phoneNumber => _phoneNumber;

  String? get commercialCertImage => _commercialCertImage;

  num? get termOfService => _termOfService;

  String? get name => _name;

  String? get businessPhoneNumber => _businessPhoneNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ownerType'] = _ownerType;
    map['businessLicense'] = _businessLicense;
    map['ownerPhoneNumber'] = _ownerPhoneNumber;
    map['country'] = _country;
    map['lastName'] = _lastName;
    map['city'] = _city;
    map['latitude'] = _latitude;
    map['language'] = _language;
    map['BusinessRegistrationPhoto'] = _businessRegistrationPhoto;
    map['commercialCertNo'] = _commercialCertNo;
    map['TaxPhoto'] = _taxPhoto;
    map['email'] = _email;
    map['longitude'] = _longitude;
    map['businessSector'] = _businessSector;
    map['Status'] = _status;
    map['TillNumberImage'] = _tillNumberImage;
    map['tillNumber'] = _tillNumber;
    map['userId'] = _userId;
    map['OwnerPhoto'] = _ownerPhoto;
    map['ShopImage'] = _shopImage;
    map['firstName'] = _firstName;
    map['phoneNumber'] = _phoneNumber;
    map['CommercialCertImage'] = _commercialCertImage;
    map['termOfService'] = _termOfService;
    map['name'] = _name;
    map['businessPhoneNumber'] = _businessPhoneNumber;
    return map;
  }
}

/// ownerType : "DISTRIBUTOR"
/// businessLicense : "0"
/// ownerPhoneNumber : "251911679409"
/// country : "ET"
/// lastName : "hassen"
/// city : 1
/// latitude : "0"
/// language : "en"
/// branch : "0"
/// commercialCertNo : "0"
/// bankAccountNumber : "0"
/// email : "ame305a@gmail.com"
/// longitude : "0"
/// Status : "1"
/// bankCode : "104"
/// tillNumber : "1000656"
/// commissionAccount : "10006561"
/// taxNumber : "0"
/// userId : 672
/// firstName : "amin"
/// phoneNumber : "251911679409"
/// termOfService : 0
/// name : "251911679409"
/// businessCategory : "1"
/// businessType : "shop"

MerchantInfo merchantInfoFromJson(String str) =>
    MerchantInfo.fromJson(json.decode(str));

String merchantInfoToJson(MerchantInfo data) => json.encode(data.toJson());

class MerchantInfo {
  MerchantInfo({
    String? ownerType,
    String? businessLicense,
    String? ownerPhoneNumber,
    String? country,
    String? lastName,
    num? city,
    String? latitude,
    String? language,
    String? branch,
    String? commercialCertNo,
    String? bankAccountNumber,
    String? email,
    String? longitude,
    String? status,
    String? bankCode,
    String? tillNumber,
    String? commissionAccount,
    String? taxNumber,
    num? userId,
    String? firstName,
    String? phoneNumber,
    num? termOfService,
    String? name,
    String? businessCategory,
    String? businessType,
  }) {
    _ownerType = ownerType;
    _businessLicense = businessLicense;
    _ownerPhoneNumber = ownerPhoneNumber;
    _country = country;
    _lastName = lastName;
    _city = city;
    _latitude = latitude;
    _language = language;
    _branch = branch;
    _commercialCertNo = commercialCertNo;
    _bankAccountNumber = bankAccountNumber;
    _email = email;
    _longitude = longitude;
    _status = status;
    _bankCode = bankCode;
    _tillNumber = tillNumber;
    _commissionAccount = commissionAccount;
    _taxNumber = taxNumber;
    _userId = userId;
    _firstName = firstName;
    _phoneNumber = phoneNumber;
    _termOfService = termOfService;
    _name = name;
    _businessCategory = businessCategory;
    _businessType = businessType;
  }

  MerchantInfo.fromJson(dynamic json) {
    _ownerType = json['ownerType'];
    _businessLicense = json['businessLicense'];
    _ownerPhoneNumber = json['ownerPhoneNumber'];
    _country = json['country'];
    _lastName = json['lastName'];
    _city = json['city'];
    _latitude = json['latitude'];
    _language = json['language'];
    _branch = json['branch'];
    _commercialCertNo = json['commercialCertNo'];
    _bankAccountNumber = json['bankAccountNumber'];
    _email = json['email'];
    _longitude = json['longitude'];
    _status = json['Status'];
    _bankCode = json['bankCode'];
    _tillNumber = json['tillNumber'];
    _commissionAccount = json['commissionAccount'];
    _taxNumber = json['taxNumber'];
    _userId = json['userId'];
    _firstName = json['firstName'];
    _phoneNumber = json['phoneNumber'];
    _termOfService = json['termOfService'];
    _name = json['name'];
    _businessCategory = json['businessCategory'];
    _businessType = json['businessType'];
  }

  String? _ownerType;
  String? _businessLicense;
  String? _ownerPhoneNumber;
  String? _country;
  String? _lastName;
  num? _city;
  String? _latitude;
  String? _language;
  String? _branch;
  String? _commercialCertNo;
  String? _bankAccountNumber;
  String? _email;
  String? _longitude;
  String? _status;
  String? _bankCode;
  String? _tillNumber;
  String? _commissionAccount;
  String? _taxNumber;
  num? _userId;
  String? _firstName;
  String? _phoneNumber;
  num? _termOfService;
  String? _name;
  String? _businessCategory;
  String? _businessType;

  MerchantInfo copyWith({
    String? ownerType,
    String? businessLicense,
    String? ownerPhoneNumber,
    String? country,
    String? lastName,
    num? city,
    String? latitude,
    String? language,
    String? branch,
    String? commercialCertNo,
    String? bankAccountNumber,
    String? email,
    String? longitude,
    String? status,
    String? bankCode,
    String? tillNumber,
    String? commissionAccount,
    String? taxNumber,
    num? userId,
    String? firstName,
    String? phoneNumber,
    num? termOfService,
    String? name,
    String? businessCategory,
    String? businessType,
  }) =>
      MerchantInfo(
        ownerType: ownerType ?? _ownerType,
        businessLicense: businessLicense ?? _businessLicense,
        ownerPhoneNumber: ownerPhoneNumber ?? _ownerPhoneNumber,
        country: country ?? _country,
        lastName: lastName ?? _lastName,
        city: city ?? _city,
        latitude: latitude ?? _latitude,
        language: language ?? _language,
        branch: branch ?? _branch,
        commercialCertNo: commercialCertNo ?? _commercialCertNo,
        bankAccountNumber: bankAccountNumber ?? _bankAccountNumber,
        email: email ?? _email,
        longitude: longitude ?? _longitude,
        status: status ?? _status,
        bankCode: bankCode ?? _bankCode,
        tillNumber: tillNumber ?? _tillNumber,
        commissionAccount: commissionAccount ?? _commissionAccount,
        taxNumber: taxNumber ?? _taxNumber,
        userId: userId ?? _userId,
        firstName: firstName ?? _firstName,
        phoneNumber: phoneNumber ?? _phoneNumber,
        termOfService: termOfService ?? _termOfService,
        name: name ?? _name,
        businessCategory: businessCategory ?? _businessCategory,
        businessType: businessType ?? _businessType,
      );

  String? get ownerType => _ownerType;

  String? get businessLicense => _businessLicense;

  String? get ownerPhoneNumber => _ownerPhoneNumber;

  String? get country => _country;

  String? get lastName => _lastName;

  num? get city => _city;

  String? get latitude => _latitude;

  String? get language => _language;

  String? get branch => _branch;

  String? get commercialCertNo => _commercialCertNo;

  String? get bankAccountNumber => _bankAccountNumber;

  String? get email => _email;

  String? get longitude => _longitude;

  String? get status => _status;

  String? get bankCode => _bankCode;

  String? get tillNumber => _tillNumber;

  String? get commissionAccount => _commissionAccount;

  String? get taxNumber => _taxNumber;

  num? get userId => _userId;

  String? get firstName => _firstName;

  String? get phoneNumber => _phoneNumber;

  num? get termOfService => _termOfService;

  String? get name => _name;

  String? get businessCategory => _businessCategory;

  String? get businessType => _businessType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ownerType'] = _ownerType;
    map['businessLicense'] = _businessLicense;
    map['ownerPhoneNumber'] = _ownerPhoneNumber;
    map['country'] = _country;
    map['lastName'] = _lastName;
    map['city'] = _city;
    map['latitude'] = _latitude;
    map['language'] = _language;
    map['branch'] = _branch;
    map['commercialCertNo'] = _commercialCertNo;
    map['bankAccountNumber'] = _bankAccountNumber;
    map['email'] = _email;
    map['longitude'] = _longitude;
    map['Status'] = _status;
    map['bankCode'] = _bankCode;
    map['tillNumber'] = _tillNumber;
    map['commissionAccount'] = _commissionAccount;
    map['taxNumber'] = _taxNumber;
    map['userId'] = _userId;
    map['firstName'] = _firstName;
    map['phoneNumber'] = _phoneNumber;
    map['termOfService'] = _termOfService;
    map['name'] = _name;
    map['businessCategory'] = _businessCategory;
    map['businessType'] = _businessType;
    return map;
  }
}
