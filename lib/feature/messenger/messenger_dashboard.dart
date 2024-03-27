import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/routes.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/login/presentation/login_page.dart';
import 'package:commercepal_admin_flutter/feature/messenger/order_items/order_items.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class MessengerDashboard extends StatefulWidget {
  static const routeName = '/messenger_dashboard';
  const MessengerDashboard({super.key});

  @override
  State<MessengerDashboard> createState() => _MessengerDashboardState();
}

class _MessengerDashboardState extends State<MessengerDashboard> {
  List<Icon> myIcons = const [
    Icon(
      Icons.lock_open,
    ),
    Icon(Icons.share_location_sharp),
    Icon(FontAwesomeIcons.arrowDownWideShort),
    Icon(FontAwesomeIcons.listCheck),
  ];
  List<String> status = [
    'Open Orders',
    'Accepted Orders',
    'Collected Orders',
    'Delivered Orders',
  ];
  var loading = false;
  String? name;
  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  void dispose() {
    // Dispose resources here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(sHeight > 896 ? sHeight * 0.27 : sHeight * 0.23),
        child: AppBar(
          primary: false,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.colorAccent,
          elevation: 1,
          bottom: PreferredSize(
            preferredSize:
                const Size.fromHeight(0), // Adjust the height as needed
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Messenger",
                            style: TextStyle(
                                fontSize: sWidth * 0.06,
                                color: AppColors.bgCreamWhite,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            bool change = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Change role'),
                                  content: const Text(
                                      'Do you want to change this role?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(
                                            false); // User does not confirm deletion
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(
                                            true); // User confirms deletion
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (change) {
                              Navigator.pop(context);
                            }
                          },
                          child: Icon(
                            Icons.change_circle_outlined,
                            color: AppColors.textColor,
                            size: sWidth * 0.08,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: sHeight * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.bgCreamWhite,
                            radius: sWidth * 0.06,
                            child: Center(
                                child: Text(loading == false && name != null
                                    ? '${name![0]}'
                                    : '')),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  loading == false && name != null ? name! : "",
                                  style: TextStyle(
                                      fontSize: sWidth * 0.05,
                                      color: AppColors.bgCreamWhite,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      "Messenger",
                                      style: TextStyle(
                                          fontSize: sWidth * 0.04,
                                          color: AppColors.textColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: sHeight * 0.05,
                        child: ElevatedButton(
                            onPressed: () async {
                              final prefsData = getIt<PrefsData>();
                              await prefsData
                                  .deleteData(PrefsKeys.userToken.name);
                              Navigator.of(navigationKey.currentContext!)
                                  .pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                      (route) => false);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.textColor),
                            child: const Text(
                              "Sign Out",
                              style: TextStyle(color: AppColors.colorAccent),
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: sHeight * 0.05,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            loading
                ? SizedBox(
                    height: sHeight * 0.5,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                    return SizedBox(
                      height: sHeight * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: sHeight > 896 ? 2 : 1.2,
                            crossAxisCount: 2, // Number of columns in the grid
                            crossAxisSpacing: 2.0, // Spacing between columns
                            mainAxisSpacing: 0, // Spacing between rows
                          ),
                          itemCount: 4, // Number of items in the grid
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                switch (status[index]) {
                                  case 'Open Orders':
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MessengerOrderItems(
                                                  orederType:
                                                      status[index].toString(),
                                                  userName: name!,
                                                )));
                                    break;
                                  case 'Accepted Orders':
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MessengerOrderItems(
                                                  orederType:
                                                      status[index].toString(),
                                                  userName: name!,
                                                )));
                                    break;
                                  case 'Collected Orders':
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MessengerOrderItems(
                                                  orederType:
                                                      status[index].toString(),
                                                  userName: name!,
                                                )));
                                    break;
                                  case 'Delivered Orders':
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MessengerOrderItems(
                                                  orederType:
                                                      status[index].toString(),
                                                  userName: name!,
                                                )));
                                    break;
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 8),
                                child: Container(
                                  height: sHeight * 0.04,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.secondaryTextColor),
                                      color: AppColors.bgCreamWhite,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: sWidth * 0.08,
                                        backgroundColor: AppColors.colorAccent,
                                        child: Center(
                                          child: myIcons[index],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          status[index],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  })
          ],
        ),
      )),
    );
  }

  Future<void> fetchUser({int retryCount = 0}) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          name = "-" + " " + "-";
        });
        print('No internet connection');
        return;
      }
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.get(
          Uri.https(
            "api.commercepal.com:2096",
            "prime/api/v1/get-details",
            {"userType": "BUSINESS"},
          ),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        print(data['statusCode']);

        if (data['statusCode'] == '000') {
          setState(() {
            name = data['Details']['firstName'] +
                " " +
                data['Details']['lastName'];
            // image = data[]
            loading = false;
            print(name);
          });
          // Handle the case when statusCode is '000'
        } else {
          // Retry logic
          if (retryCount < 5) {
            // Retry after num + 1 seconds
            await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await fetchUser(retryCount: retryCount + 1);
          } else {
            // Retry limit reached, handle accordingly
            setState(() {
              name = "- -";
              loading = false;
            });
          }
        }
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        name = "- -";
        loading = false;
      });
      // Handle other exceptions
    }
  }
}
