import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../feature/splash/splash_page.dart';
import 'app_theme.dart';
import 'utils/routes.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          AppColors.colorAccent, // Set your desired status bar color
    ));
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.themeData(context),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [],
        routes: routes,
        navigatorKey: navigationKey,
        initialRoute: SplashPage.routeName,
        home: child,
      ),
    );
  }
}
