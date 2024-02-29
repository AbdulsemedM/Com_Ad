import 'package:commercepal_admin_flutter/core/database/data_helper/data_helper.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/core/model/user.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: DataHelper)
class DataHelperImpl implements DataHelper {
  final PrefsData prefsData;

  DataHelperImpl(this.prefsData);

  @override
  Future<User> getUser() async {
    try {
      if (!await prefsData.contains(PrefsKeys.user.name)) {
        throw 'User not found';
      }
      final userInString = await prefsData.readData(PrefsKeys.user.name);
      return userResponseDtoFromJson(userInString!);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveUser(User user) async {
    try {
      await prefsData.writeData(
          PrefsKeys.user.name, userResponseDtoToJson(user));
    } catch (e) {
      rethrow;
    }
  }
}
