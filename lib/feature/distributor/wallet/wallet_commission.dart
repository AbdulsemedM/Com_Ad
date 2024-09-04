import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/distributor/wallet/wallet_transactions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WalletCommission extends StatefulWidget {
  const WalletCommission({super.key});

  @override
  State<WalletCommission> createState() => _WalletCommissionState();
}

class _WalletCommissionState extends State<WalletCommission> {
  var loading = false;
  List<WalletTransactionData> trnxs = [];
  @override
  void initState() {
    super.initState();
    fetchTrnxsdata();
  }

  @override
  Widget build(BuildContext context) {
    var sWidth = MediaQuery.of(context).size.width * 1;
    var sHeight = MediaQuery.of(context).size.height * 1;
    return loading && trnxs.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CircularProgressIndicator(),
              ),
              Text("Fetching Transactions")
            ],
          )
        : SizedBox(
            height: sHeight * 0.3,
            child: ListView.builder(
                itemCount: trnxs.length,
                itemBuilder: (BuildContext, index) {
                  return Card(
                    shadowColor: AppColors.colorAccent,
                    elevation: 2,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(trnxs[index].TransRef),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(trnxs[index].TransType,
                                      style:
                                          TextStyle(fontSize: sWidth * 0.02)),
                                ),
                                Text(trnxs[index].Narration,
                                    style: TextStyle(fontSize: sWidth * 0.03)),
                              ],
                            ),
                            Text(
                                "${trnxs[index].Amount} ${trnxs[index].Currency}",
                                style: TextStyle(
                                    fontSize: sWidth * 0.04,
                                    color: AppColors.purple)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Divider(
                            thickness: sHeight * 0.001,
                          ),
                        ),
                        Text(
                            DateFormat('dd MMM, HH:mm')
                                .format(DateTime.parse(trnxs[index].TransDate)),
                            style: TextStyle(fontSize: sWidth * 0.03))
                      ],
                    ),
                  );
                }),
          );
  }

  Future<void> fetchTrnxsdata({int retryCount = 0}) async {
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
            "api.commercepal.com:2095",
            "/prime/api/v1/distributor/transaction/transactions",
            {"accountType": "COMMISSION"},
          ),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        // print(data);

        if (data['Status'] == '00') {
          setState(() {
            for (var datas in data['List']) {
              trnxs.add(WalletTransactionData(
                  TransType: datas['TransType'],
                  TransRef: datas['TransRef'],
                  Amount: datas['Amount'].toString(),
                  Currency: datas['Currency'],
                  Narration: datas['Narration'],
                  TransDate: datas['TransDate']));
            }
            loading = false;
          });
          print(trnxs.length);
          // Handle the case when statusCode is '000'
        } else {
          // Retry logic
          if (retryCount < 5) {
            // Retry after num + 1 seconds
            await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await fetchTrnxsdata(retryCount: retryCount + 1);
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
