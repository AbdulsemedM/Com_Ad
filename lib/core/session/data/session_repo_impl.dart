import 'dart:developer';

import 'package:commercepal_admin_flutter/core/database/data_helper/data_helper.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/core/model/roles.dart';
import 'package:commercepal_admin_flutter/core/model/user.dart';
import 'package:commercepal_admin_flutter/core/session/domain/session_repo.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../database/prefs_data.dart';

@Injectable(as: SessionRepo)
class SessionRepoImpl implements SessionRepo {
  final DataHelper dataHelper;
  final PrefsData prefsData;

  SessionRepoImpl(this.dataHelper, this.prefsData);

  @override
  Future<User> getUser() async {
    try {
      final userExists = await prefsData.contains(PrefsKeys.user.name);
      if (!userExists) {
        throw 'User not found';
      }
      return await dataHelper.getUser();
    } catch (e) {
      rethrow;
    }
  }
}
