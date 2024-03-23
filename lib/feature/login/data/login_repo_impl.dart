import 'dart:convert';

// import 'package:commercepal_admin_flutter/app/utils/routes.dart';
// import 'package:commercepal_admin_flutter/feature/login/presentation/login_page.dart';
// import 'package:commercepal_admin_flutter/app/utils/roles/roles_checker.dart';
// import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/database/data_helper/data_helper.dart';
import '../../../core/database/prefs_data.dart';
import '../../../core/database/prefs_data_impl.dart';
import '../../../core/exceptions/change_pin_exception.dart';
import '../../../core/exceptions/not_supported_exception.dart';
import '../../../core/model/roles.dart';
import '../../../core/model/user.dart';
import '../../../core/network/api_provider.dart';
import '../../../core/network/end_points.dart';
import '../domain/login_repo.dart';
import 'dto/login_response_dto.dart';
import 'package:http/http.dart' as http;

@Injectable(as: LoginRepo)
class LoginRepoImpl implements LoginRepo {
  final ApiProvider apiProvider;
  final PrefsData prefsData;
  final DataHelper dataHelper;

  LoginRepoImpl(this.apiProvider, this.prefsData, this.dataHelper);

  @override
  Future<String> login(String email, String password) async {
    try {
      final payload = {"email": email, "password": password};
      final response = await apiProvider.post(payload, EndPoints.login.url);
      if (json.decode(response)['statusCode'] != '000') {
        throw jsonDecode(response)['statusMessage'];
      }

      final loginResponseObj = loginResponseDtoFromJson(response);
      // save token
      await prefsData.writeData(
          PrefsKeys.userToken.name, loginResponseObj.userToken!);
      // check pin
      if (loginResponseObj.changePin == 0) {
        // navigator
        throw ChangePinException("Please change your pin to continue");
      }

      // get user details
      final userResponse = await apiProvider.get(EndPoints.userDetails.url);
      final userResponseObj = User.fromJson(userResponse);

      // set roles
      final userRoles = <Role>[];
      if (userResponseObj.isAgent == "YES") userRoles.add(Role.agent);
      if (userResponseObj.isBusiness == "YES") userRoles.add(Role.business);
      if (userResponseObj.isDistributor == "YES") {
        userRoles.add(Role.distributor);
      }
      if (userResponseObj.isMessenger == "YES") userRoles.add(Role.messenger);
      if (userResponseObj.isMerchant == "YES") userRoles.add(Role.merchant);

      // only merchant is allowed for now
      // if (userResponseObj.isMerchant != "YES") {
      //   throw NotSupportedException(
      //       "Only merchant services are supported at the moment");
      // }
      List<String> myRole = [];
      for (var role in userRoles) {
        myRole.add(role.toString());
        print(myRole);
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList("myRole", myRole);
      final warehouse = await http.post(
          Uri.https("api.commercepal.com:2052", "/api/v1/admin/authenticate"),
          body: jsonEncode(payload));
      var myWare = jsonDecode(warehouse.body);
      print("herereisthewarehouse");
      print(myWare);
      if (myWare['statusCode'] == '000') {
        print("hererererere");
        prefs.setString('warehouse', myWare['userToken']);
      } else {
        print("herererererenotttt");
        prefs.setString('warehouse', '');
      }

      // save user
      await dataHelper.saveUser(userResponseObj);
      print('herewegoooo');
      print(userRoles);
      // if (userRoles.isNotEmpty && userRoles.length > 1) {
      //   return userRoles;
      // }
      return userRoles.isNotEmpty
          ? 'Logged in successfully'
          : 'Welcome to admin services';
    } catch (e) {
      rethrow;
    }
  }
}
