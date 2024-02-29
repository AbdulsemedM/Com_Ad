import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OverviewTab extends StatefulWidget {
  const OverviewTab({super.key});

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  String agent = '0';
  String merchant = '0';
  String total = '0';
  String business = '0';
  var loading = false;
  @override
  void initState() {
    super.initState();
    fetchDashboardData(retryCount: 0);
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return Stack(children: [
      Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: <Widget>[
                  // Larger rectangle (blue)
                  Container(
                      width: sWidth * 1,
                      height: MediaQuery.of(context).size.height * 0.23,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 0),
                            child: Row(
                              children: [
                                Center(
                                    child: Text(
                                  total,
                                  style: TextStyle(
                                      fontSize: sWidth * 0.05,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryTextColor),
                                )),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 16),
                            child: Text(
                              "TOTAL REGISTERED PERSON",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.secondaryTextColor),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 0, 10),
                                child: Column(
                                  children: [
                                    Text(
                                      agent,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primaryTextColor),
                                    ),
                                    const Text(
                                      "Agents",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.secondaryTextColor),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 0, 10),
                                child: Column(
                                  children: [
                                    Text(
                                      business,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primaryTextColor),
                                    ),
                                    const Text(
                                      "Businesses",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.secondaryTextColor),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 0, 10),
                                child: Column(
                                  children: [
                                    Text(
                                      merchant,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primaryTextColor),
                                    ),
                                    const Text(
                                      "Merchants",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.secondaryTextColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Positioned(
                    // bottom: sWidth * 0.55,
                    bottom: sWidth * 0.27,
                    // top: sWidth * -0.2,
                    top: sWidth * -0.2,
                    // right: sWidth * 0.05,
                    right: sWidth * 0.05,
                    // left: sWidth * 0.5,
                    left: sWidth * 0.55,
                    child: Container(
                      child: SizedBox(
                          child: Center(
                        child: Image(
                            height: sHeight * 0.0,
                            image: AssetImage("assets/images/medal.png")),
                      )),
                      width: sWidth * 0.1,
                      height: MediaQuery.of(context).size.height * 0.04,
                      decoration: BoxDecoration(
                          color: Color(0xFF990E5E).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: sHeight * 0.24,
              decoration: BoxDecoration(
                  color: AppColors.textColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '23',
                          style: TextStyle(
                              fontSize: sWidth * 0.09,
                              color: AppColors.colorPrimary),
                        ),
                        Text(
                          'PENDING REGISTRATIONS',
                          style: TextStyle(
                              fontSize: sWidth * 0.035,
                              color: AppColors.colorPrimary),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'See All',
                              style: TextStyle(
                                  fontSize: sWidth * 0.04,
                                  color: AppColors.colorPrimary),
                            ),
                            Icon(
                              Icons.arrow_right_alt_rounded,
                              color: AppColors.colorPrimary,
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Image(
                              width: sWidth * 0.2,
                              image: AssetImage(
                                  "assets/images/computer_workspace.png")),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      
    ]);
  }

  Future<void> fetchDashboardData({int retryCount = 0}) async {
    try {
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
            "/prime/api/v1/distributor/get-dashboard",
          ),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          setState(() {
            agent = data['data']['Agent'].toString();
            merchant = data['data']['Merchant'].toString();
            total = data['data']['Total'].toString();
            business = data['data']['Business'].toString();
            loading = false;
          });
          // Handle the case when statusCode is '000'
        } else {
          // Retry logic
          if (retryCount < 5) {
            // Retry after num + 1 seconds
            await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await fetchDashboardData(retryCount: retryCount + 1);
          } else {
            // Retry limit reached, handle accordingly
            setState(() {
              loading = false;
            });
          }
        }
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      // Handle other exceptions
    }
  }
}
