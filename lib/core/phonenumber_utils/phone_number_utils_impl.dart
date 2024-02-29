import 'dart:io';

import 'package:commercepal_admin_flutter/core/phonenumber_utils/phone_number_utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:phone_number/phone_number.dart';

@Injectable(as: PhoneNumberUtils)
class PhoneNumberUtilsImpl implements PhoneNumberUtils {
  Future<PhoneNumber?> customPhoneNumberParser(String phoneNumber) async {
    try {
      return await PhoneNumberUtil().parse(phoneNumber);
    } catch (e) {
      Fimber.e('Unable to parse phone number');
    }
    return null;
  }

  /// validates phone number
  @override
  Future<bool> validateMobileApi(String phone, String countryCode) async {
    // try parsing the phone number
    try {
      return await PhoneNumberUtil().validate(phone, regionCode: countryCode);
    } catch (e) {
      Fimber.e(e.toString());
      return false;
    }
  }

  bool validateMobileCI(String value) {
    var regExp =
        RegExp(r'^(?:(?:\+[0-9]{12})|(?:\b0[0-9]{9}\b)|(?:\b251[0-9]{9}\b))$');
        
    return regExp.hasMatch(value);

  }

  @override
  Future<String?> passPhoneToIso(String phoneNumber, String countryCode) async {
    try {
      final parsedPhone =
          await PhoneNumberUtil().parse(phoneNumber, regionCode: countryCode);
      return parsedPhone.e164.replaceFirst("+", "");
    } catch (e) {
      Fimber.e('Error parsing phone number : ${e}');
    }
    return null;
  }

  @override
  Future<bool?> validateEmail(String email) async {
    return EmailValidator.validate(email);
  }
}
