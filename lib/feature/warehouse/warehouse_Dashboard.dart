import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/routes.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:commercepal_admin_flutter/feature/login/presentation/login_page.dart';
import 'package:commercepal_admin_flutter/feature/warehouse/accept_warehouse_to_warehouse.dart';
import 'package:commercepal_admin_flutter/feature/warehouse/merchant_to_warehouse.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class WarehouseDashboard extends StatefulWidget {
  static const routeName = '/warehouse_dashboard';
  const WarehouseDashboard({Key? key}) : super(key: key);

  @override
  State<WarehouseDashboard> createState() => _WarehouseDashboardState();
}

class _WarehouseDashboardState extends State<WarehouseDashboard> {
  String? name;
  var loading = false;
  List<String> status = ['From Messenger', 'From Warehouse', 'To warehouse'];
  List<Icon> myIcons = const [
    Icon(
      FontAwesomeIcons.clipboardCheck,
    ),
    Icon(Icons.warehouse_outlined),
    Icon(FontAwesomeIcons.shareFromSquare),
  ];
  @override
  void initState() {
    super.initState();
    fetchUser();
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
                            "Warehouse",
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
                                child: Text(!loading && name!.isNotEmpty
                                    ? '${name![0]}'
                                    : '')),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  !loading && name!.isNotEmpty ? name! : "",
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
                                      "Warehouse",
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
                            onPressed: () {
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
            SizedBox(
              height: sHeight * 0.5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: sHeight > 896 ? 2 : 1,
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: 2.0, // Spacing between columns
                    mainAxisSpacing: 4.0, // Spacing between rows
                  ),
                  itemCount: 3, // Number of items in the grid
                  itemBuilder: (context, index) {
                    return loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : GestureDetector(
                            onTap: () {
                              switch (status[index]) {
                                case 'From Messenger':
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MerchantToWarehouse(
                                                userName: name!,
                                              )));
                                  break;
                                case 'To warehouse':
                                  context
                                      .displaySnack("Will be available soon");
                                  break;
                                case 'From Warehouse':
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AcceptItemsFromWarehouse(
                                                userName: name!,
                                              )));
                                  break;
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 8),
                              child: Container(
                                height: sHeight * 0.05,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.secondaryTextColor),
                                    color: AppColors.bgCreamWhite,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
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
                                    CircleAvatar(
                                      radius: sWidth * 0.08,
                                      backgroundColor: AppColors.colorAccent,
                                      child: Center(
                                        child: myIcons[index],
                                      ),
                                    )
                                  ],
                                )),
                              ),
                            ),
                          );
                  },
                ),
              ),
            )
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
              loading = false;
            });
          }
        }
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
      // Handle other exceptions
    }
  }
}
