import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../app/di/injector.dart';
import '../../database/prefs_data.dart';
import '../../database/prefs_data_impl.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final prefsData = getIt<PrefsData>();

    final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
    if (isUserLoggedIn) {
      final token = await prefsData.readData(PrefsKeys.userToken.name);
      options.headers['Authorization'] = "Bearer $token";
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(jsonEncode(response.data));
    super.onResponse(response, handler);
  }
}
