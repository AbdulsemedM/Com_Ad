import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import 'prefs_data.dart';

enum PrefsKeys { user, userToken }

@Injectable(as: PrefsData)
class PrefsDataImpl implements PrefsData {
  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();

  PrefsDataImpl();

  @override
  Future<String?> readData(String key) async {
    if (await flutterSecureStorage.containsKey(key: key)) {
      return await flutterSecureStorage.read(key: key);
    } else {
      return null;
    }
  }

  @override
  Future writeData(String key, String data) async {
    await flutterSecureStorage.write(key: key, value: data);
  }

  @override
  Future<bool> contains(String key) async {
    return await flutterSecureStorage.containsKey(key: key);
  }

  @override
  Future deleteData(String key) async {
    await flutterSecureStorage.delete(key: key);
  }

  @override
  Future nuke() async {
    await flutterSecureStorage.deleteAll();
  }
}
