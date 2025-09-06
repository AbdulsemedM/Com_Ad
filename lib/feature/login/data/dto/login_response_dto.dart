import 'dart:convert';

LoginResponseDto loginResponseDtoFromJson(String str) =>
    LoginResponseDto.fromJson(json.decode(str));

String loginResponseDtoToJson(LoginResponseDto data) =>
    json.encode(data.toJson());

class LoginResponseDto {
  LoginResponseDto({
    String? userToken,
    String? statusDescription,
    bool? isPhoneValidated,
    bool? isEmailValidated,
    num? changePin,
    String? statusMessage,
    String? statusCode,
    String? refreshToken,
  }) {
    _userToken = userToken;
    _statusDescription = statusDescription;
    _isPhoneValidated = isPhoneValidated;
    _isEmailValidated = isEmailValidated;
    _changePin = changePin;
    _statusMessage = statusMessage;
    _statusCode = statusCode;
    _refreshToken = refreshToken;
  }

  LoginResponseDto.fromJson(dynamic json) {
    _userToken = json['userToken'];
    _statusDescription = json['statusDescription'];
    _isPhoneValidated = json['isPhoneValidated'];
    _isEmailValidated = json['isEmailValidated'];
    _changePin = json['changePin'];
    _statusMessage = json['statusMessage'];
    _statusCode = json['statusCode'];
    _refreshToken = json['refreshToken'];
  }

  String? _userToken;
  String? _statusDescription;
  bool? _isPhoneValidated;
  bool? _isEmailValidated;
  num? _changePin;
  String? _statusMessage;
  String? _statusCode;
  String? _refreshToken;

  LoginResponseDto copyWith({
    String? userToken,
    String? statusDescription,
    bool? isPhoneValidated,
    bool? isEmailValidated,
    num? changePin,
    String? statusMessage,
    String? statusCode,
    String? refreshToken,
  }) =>
      LoginResponseDto(
        userToken: userToken ?? _userToken,
        statusDescription: statusDescription ?? _statusDescription,
        isPhoneValidated: isPhoneValidated ?? _isPhoneValidated,
        isEmailValidated: isEmailValidated ?? _isEmailValidated,
        changePin: changePin ?? _changePin,
        statusMessage: statusMessage ?? _statusMessage,
        statusCode: statusCode ?? _statusCode,
        refreshToken: refreshToken ?? _refreshToken,
      );

  String? get userToken => _userToken;

  String? get statusDescription => _statusDescription;

  bool? get isPhoneValidated => _isPhoneValidated;

  bool? get isEmailValidated => _isEmailValidated;

  num? get changePin => _changePin;

  String? get statusMessage => _statusMessage;

  String? get statusCode => _statusCode;

  String? get refreshToken => _refreshToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userToken'] = _userToken;
    map['statusDescription'] = _statusDescription;
    map['isPhoneValidated'] = _isPhoneValidated;
    map['isEmailValidated'] = _isEmailValidated;
    map['changePin'] = _changePin;
    map['statusMessage'] = _statusMessage;
    map['statusCode'] = _statusCode;
    map['refreshToken'] = _refreshToken;
    return map;
  }
}
