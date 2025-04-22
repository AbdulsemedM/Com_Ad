import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/core/network/api_provider.dart';
import 'package:http/http.dart' as http;

class NewMessengerDataProvider {
  final ApiProvider? apiProvider;
  NewMessengerDataProvider({this.apiProvider});
  Future<String> fetchDeliveryItems() async {
    final prefsData = getIt<PrefsData>();
    final token = await prefsData.readData(PrefsKeys.userToken.name);
    try {
      final response = await http.get(
          Uri.parse(
              "https://api.commercepal.com:2096/prime/api/v1/messenger/shipping/deliveries"),
          headers: <String, String>{
            "Authorization":
                "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhYmRpdHJuaGRldkBnbWFpbC5jb20iLCJleHAiOjIzNDk1MDY5MDMsImlhdCI6MTc0NDcwNjkwM30.eogMGCsQT2icTrctpsEVME3Ese_UgtkqDIzuEyyejqh8Or7ZG8zNtPXIcSGR8AicIbpdV7fgbfxqxuyZ_TskNQ"
          });
      print(response.body);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
  Future<String> fetchDeliveryItemDetails(String id) async {
    final prefsData = getIt<PrefsData>();
    final token = await prefsData.readData(PrefsKeys.userToken.name);
    try {
      final response = await http.get(
          Uri.parse(
              "https://api.commercepal.com:2096/prime/api/v1/messenger/shipping/deliveries/$id"),
          headers: <String, String>{
            "Authorization":
                "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhYmRpdHJuaGRldkBnbWFpbC5jb20iLCJleHAiOjIzNDk1MDY5MDMsImlhdCI6MTc0NDcwNjkwM30.eogMGCsQT2icTrctpsEVME3Ese_UgtkqDIzuEyyejqh8Or7ZG8zNtPXIcSGR8AicIbpdV7fgbfxqxuyZ_TskNQ"
          });
      print(response.body);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
