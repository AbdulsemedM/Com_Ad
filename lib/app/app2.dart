import 'dart:convert';

import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../feature/splash/splash_page.dart';
import 'app_theme.dart';
import 'utils/routes.dart';
import 'package:http/http.dart' as http;

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class CountryData {
  final String country;
  final String countryCode;
  CountryData({required this.country, required this.countryCode});
}

class _AppState extends State<App> {
  bool _isCountryFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isCountryFetched) {
      fetchCountry();
    }
  }

  List<CountryData> countries = [];
  var loading = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          AppColors.colorAccent, // Set your desired status bar color
    ));
    if (_isCountryFetched) {
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
    } else {
      return Directionality(
        textDirection: TextDirection.ltr, // Set the text direction
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    Assets.managementAppLogo,
                    // width: 150,
                    // height: 150,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<bool> fetchCountry() async {
    try {
      setState(() {
        loading = true;
      });
      final response = await http.get(Uri.https(
          "api.commercepal.com:2096", "/prime/api/v1/service/countries"));
      var data = jsonDecode(response.body);
      countries.clear();
      for (var b in data['data']) {
        countries.add(
            CountryData(countryCode: b['countryCode'], country: b['country']));
      }
      print(countries.length);
      setState(() {
        _isCountryFetched = true;
        loading = false;
      });
      return true;
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
      return false;
    }
  }
}
