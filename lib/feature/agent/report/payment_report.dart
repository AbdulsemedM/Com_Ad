import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentReport extends StatefulWidget {
  const PaymentReport({super.key});

  @override
  State<PaymentReport> createState() => _PaymentReportState();
}

class ReportPayment {
  final String Narration;
  final String Amount;
  final String TransRef;
  final String TransType;
  ReportPayment(
      {required this.Narration,
      required this.TransRef,
      required this.Amount,
      required this.TransType});
}

class _PaymentReportState extends State<PaymentReport> {
  void initState() {
    super.initState();
    fetchOrderData();
  }

  List<ReportPayment> reports = [];
  var loading = false;
  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return loading == false && reports.isNotEmpty
        ? Column(
            children: [
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: SizedBox(
                  height: sHeight * 0.65,
                  child: ListView.builder(
                      itemCount: reports.length,
                      itemBuilder: (BuildContext, index) {
                        return Card(
                          shadowColor: AppColors.colorAccent,
                          elevation: 2,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(reports[index].TransRef),
                                  ),
                                  Text(reports[index].TransType,
                                      style:
                                          TextStyle(fontSize: sWidth * 0.03)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(reports[index].Amount,
                                        style:
                                            TextStyle(fontSize: sWidth * 0.02)),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Divider(
                                  thickness: sHeight * 0.001,
                                ),
                              ),
                              Text(reports[index].Narration,
                                  style: TextStyle(fontSize: sWidth * 0.03))
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ],
          )
        : loading == false && reports.isEmpty
            ? Center(
                child: SizedBox(
                // height: sHeight * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                        height: sHeight * 0.4,
                        image:
                            const AssetImage("assets/images/mobile_user.png")),
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text("There are no orders to show."),
                    ),
                  ],
                ),
              ))
            : loading == true
                ? const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.colorAccent,
                          ),
                          Text("Fetching Orders data..."),
                        ],
                      ),
                    ),
                  )
                : Container();
  }

  Future<void> fetchOrderData({int retryCount = 0}) async {
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
            "/prime/api/v1/agent/transaction/payment-summary",
          ),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        Map<String, dynamic> data = json.decode(response.body);
        print(data);

        print(data['statusCode']);
        if (data['statusCode'] == '000') {
          setState(() {
            for (var datas in data['details']) {
              reports.add(ReportPayment(
                Narration: datas['Narration'],
                TransRef: datas['TransRef'],
                Amount: datas['Amount'],
                TransType: datas['TransType'],
              ));
            }
            loading = false;
          });
          print("hey merchant");
          print(reports.length);
          // Handle the case when statusCode is '000'
        } else {
          // Retry logic
          if (retryCount < 5) {
            // Retry after num + 1 seconds
            await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await fetchOrderData(retryCount: retryCount + 1);
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
        print(e.toString());
        loading = false;
      });
      // Handle other exceptions
    }
  }
}
