import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:commercepal_admin_flutter/feature/agent/agent_dashboard.dart';
import 'package:commercepal_admin_flutter/feature/distributor/distributor_dashboard.dart';
import 'package:commercepal_admin_flutter/feature/login/presentation/login_page.dart';
import 'package:commercepal_admin_flutter/feature/merchant/dashboard/merchant_dashboard_page.dart';
import 'package:commercepal_admin_flutter/feature/messenger/messenger_dashboard.dart';
import 'package:commercepal_admin_flutter/feature/reset_password/reset_password.dart';
import 'package:commercepal_admin_flutter/feature/warehouse/warehouse_Dashboard.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RoleChecker extends StatefulWidget {
  static const routeName = "/roles";
  const RoleChecker({super.key});

  @override
  State<RoleChecker> createState() => _RoleCheckerState();
}

class _RoleCheckerState extends State<RoleChecker> {
  @override
  void initState() {
    super.initState();
    getRoles();
    fetchUser();
  }

  String? name;
  String? image;
  var loading = false;
  List<String>? myRoles = [];
  String myWarehouse = "";

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(sHeight * 0.3),
        child: AppBar(
          // title: Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 20.0),
          //   child: Text(
          //     "Choose Role",
          //     style: TextStyle(
          //         fontSize: sWidth * 0.06,
          //         color: AppColors.bgCreamWhite,
          //         fontWeight: FontWeight.bold),
          //   ),
          // ),
          backgroundColor: AppColors.colorAccent,
          elevation: 1, // Set elevation to 0 to remove shadow
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          bottom: PreferredSize(
            preferredSize:
                const Size.fromHeight(0), // Adjust the height as needed
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          "Choose Role",
                          style: TextStyle(
                              fontSize: sWidth * 0.06,
                              color: AppColors.bgCreamWhite,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(18.0),
                      //   child: GestureDetector(
                      //     onTap: () async {},
                      //     child: Icon(
                      //       Icons.logout,
                      //       color: AppColors.bgCreamWhite,
                      //     ),
                      //   ),
                      // ),
                      PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'reset') {
                            Navigator.pushNamed(
                                context, ResetPassword1.routeName,
                                arguments: {"router": "role"});
                            // print(result);
                            // if (result) {
                            // final prefsData = getIt<PrefsData>();
                            // await prefsData
                            //     .deleteData(PrefsKeys.userToken.name);
                            // ignore: use_build_context_synchronously
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const LoginPage()));
                            // }
                          } else if (value == 'logout') {
                            final prefsData = getIt<PrefsData>();
                            await prefsData
                                .deleteData(PrefsKeys.userToken.name);
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'reset',
                            child: Text('Reset password'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'logout',
                            child: Text('Logout'),
                          ),
                        ],
                        color: AppColors.bgCreamWhite,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.bgCreamWhite,
                          radius: sWidth * 0.06,
                          child: Center(
                              child: loading
                                  ? Container()
                                  : Text(loading == false && name != null
                                      ? '${name![0]}'
                                      : '')),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: loading
                              ? Container()
                              : Text(
                                  loading == false && name != null ? name! : "",
                                  // '${name!.isNotEmpty ? name : ""}',
                                  style: TextStyle(
                                      fontSize: sWidth * 0.07,
                                      color: AppColors.bgCreamWhite,
                                      fontWeight: FontWeight.bold),
                                ),
                        )
                      ],
                    ),
                  ),
                  myWarehouse != '' && !loading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              WarehouseDashboard()));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.textColor),
                                child: const Text(
                                  "Go to warehouse",
                                  style:
                                      TextStyle(color: AppColors.colorAccent),
                                )),
                            SizedBox(
                              height: sHeight * 0.09,
                            ),
                          ],
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: sHeight * 0.05),
              child: Text("choose the role you want to proceed"),
            ),
          ),
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              height: sHeight > 896 ? sHeight * 0.3 : sHeight * 0.2,
              width: sWidth * 0.8,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 2,
                  crossAxisCount: 2, // Number of columns in the grid
                  crossAxisSpacing: 8.0, // Spacing between columns
                  mainAxisSpacing: 8.0, // Spacing between rows
                ),
                itemCount: myRoles!.length, // Number of items in the grid
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      switch (myRoles![index].toLowerCase()) {
                        case "messenger":
                          Navigator.pushNamed(
                              context, MessengerDashboard.routeName);
                          break;
                        case "distributor":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DistributorDashboard()),
                          );
                          break;
                        case "merchant":
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MerchantDashboardPage()));
                          break;
                        case "agent":
                          Navigator.pushNamed(
                              context, AgentDashboard.routeName);
                          break;
                        case "business":
                          context.displaySnack("Will be available soon");
                          break;
                      }
                    },
                    child: Container(
                      height: sHeight * 0.02,
                      decoration: BoxDecoration(
                          color: AppColors.bgCreamWhite,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          myRoles![index].toLowerCase() == "merchant"
                              ? const Icon(FontAwesomeIcons.store)
                              : myRoles![index].toLowerCase() == "messenger"
                                  ? const Icon(FontAwesomeIcons.motorcycle)
                                  : myRoles![index].toLowerCase() ==
                                          "distributor"
                                      ? const Icon(FontAwesomeIcons
                                          .buildingCircleArrowRight)
                                      : myRoles![index].toLowerCase() ==
                                              "business"
                                          ? const Icon(
                                              FontAwesomeIcons.briefcase)
                                          : myRoles![index].toLowerCase() ==
                                                  "admin"
                                              ? const Icon(
                                                  FontAwesomeIcons.userTie)
                                              : myRoles![index].toLowerCase() ==
                                                      "agent"
                                                  ? const Icon(FontAwesomeIcons
                                                      .userCheck)
                                                  : const Icon(
                                                      Icons.numbers_outlined),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(myRoles![index]),
                          ),
                        ],
                      )),
                    ),
                  );
                },
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: GestureDetector(
              onTap: () async {
                final prefsData = getIt<PrefsData>();
                await prefsData.deleteData(PrefsKeys.userToken.name);
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: const Text(
                "Logout",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.colorAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          )
        ],
      )),
    );
  }

  Future<void> getRoles() async {
    try {
      List<String>? roles = [];
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        roles = prefs.getStringList("myRole");
        myWarehouse =
            prefs.getString("warehouse") ?? ""; // Use null-aware operator
        print("myWarehouse");
        print(myWarehouse);

        myRoles = roles
            ?.map((role) => role
                .toString()
                .replaceAll('Role.', '') // Remove 'Role.' prefix
                .toLowerCase()) // Convert the entire string to lowercase
            ?.map(capitalizeFirstLetter) // Capitalize the first letter
            ?.toList();
      });
      print(myRoles?.length);
    } catch (e) {
      print(e.toString());
    }
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input; // Return empty string for an empty input
    }
    return input[0].toUpperCase() + input.substring(1);
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
        print(data);

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
              name = "-" + " " + "-";
              loading = false;
            });
          }
        }
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        name = "-" + " " + "-";
        loading = false;
      });
      // Handle other exceptions
    }
  }
}
