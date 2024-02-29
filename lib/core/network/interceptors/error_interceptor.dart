import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../app/utils/routes.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log(err.toString());
    switch (err.type) {
      case DioErrorType.cancel:
      case DioErrorType.receiveTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.connectionTimeout:
        err = err.copyWith(
            message:
                'An error occurred while attempting to connect to our servers');
        break;
      case DioErrorType.unknown:
        if (err.error is SocketException) {
          err = err.copyWith(
              message:
                  'Server is not reachable. Please verify your internet connection and try again');
        } else {
          err = err.copyWith(
              message:
                  'Looks like something went wrong while processing your request');
        }
        break;
      case DioErrorType.badResponse:
        if (err.response?.data != null) {
          if (err.response?.data is String) {
            err = err.copyWith(
                message:
                    'Looks like something went wrong while processing your request! Kindly try later');
          } else {
            String? error = err.response!.data['message'] as String;
            err = err.copyWith(message: error);
          }
        } else {
          err = err.copyWith(
              message:
                  'Looks like something went wrong while processing your request! Kindly try later');
        }
        if (err.response?.statusCode == 404) {
          err = err.copyWith(
              message: '${err.response?.statusCode} Page not found.');
        }
        if (err.response?.statusCode == 500) {
          err = err.copyWith(
              message: '${err.response?.statusCode} Internal server error.');
        }
        if (err.response?.statusCode == 403 ||
            err.response?.statusCode == 401) {
          redirectUserToLogin();
        }
        break;
      default:
        err = err.copyWith(
            message:
                'Looks like something went wrong while processing your request! Kindly try later');
    }
    super.onError(err, handler);
  }
}
