import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:commercepal_admin_flutter/app/app.dart';
import 'package:commercepal_admin_flutter/core/network/api_provider.dart';
import 'package:commercepal_admin_flutter/feature/new_messenger/bloc/new_messenger_bloc.dart';
import 'package:commercepal_admin_flutter/feature/new_messenger/data/data_provider/new_messenger_data_provider.dart';
import 'package:commercepal_admin_flutter/feature/new_messenger/data/repository/new_messenger_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:upgrader/upgrader.dart';
import 'app/di/injector.dart';
import 'app/utils/app_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Upgrader.clearSavedSettings();
  await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  await OneSignal.shared.setAppId('93ea5812-db88-42b8-abc2-010c99e48b56');
  bool accepted =
      await OneSignal.shared.promptUserForPushNotificationPermission();
  print("Accepted Permission: $accepted");
  await configureInjection(Environment.prod);

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarColor: Colors.white, // status bar color
    ));
  }

  Bloc.observer = AppBlocObserver();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => NewMessengerBloc(
            NewMessengerRepository(NewMessengerDataProvider())),
      ),
      // BlocProvider(
      //   create: (context) => SubjectBloc(),
      // ),
    ],
    child: App(),
  ));
}
