import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/merchant/promo_code/add_promo_code.dart';
import 'package:commercepal_admin_flutter/feature/merchant/promo_code/edit_promo_code_dialog.dart';
import 'package:commercepal_admin_flutter/feature/merchant/promo_code/promo_code_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PromoCodeDashboard extends StatefulWidget {
  const PromoCodeDashboard({super.key});

  @override
  State<PromoCodeDashboard> createState() => _PromoCodeDashboardState();
  static void FetchthePromocodes(BuildContext context) {
    final _PromoCodeDashboardState state =
        context.findAncestorStateOfType<_PromoCodeDashboardState>()!;
    state.fetchMyPromoCodes();
  }
}

class PromoCodes {
  final String id;
  final String code;
  final String productId;
  final String subProductId;
  final String merchantId;
  final String discountAmount;
  final String discountType;
  final String startDate;
  final String endDate;
  final String promoCodeStatus;
  final String status;
  final String promoCodeDescription;
  PromoCodes(
      {required this.id,
      required this.code,
      required this.productId,
      required this.merchantId,
      required this.discountAmount,
      required this.discountType,
      required this.startDate,
      required this.endDate,
      required this.status,
      required this.subProductId,
      required this.promoCodeDescription,
      required this.promoCodeStatus});
}

class _PromoCodeDashboardState extends State<PromoCodeDashboard> {
  var loading = false;
  List<PromoCodes> myPromocodes = [];
  @override
  void initState() {
    super.initState();
    fetchMyPromoCodes();
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.bg1,
      // appBar: AppBar(
      //   title: Text("Promo-Code",
      //       style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.colorPrimaryDark),
                      onPressed: () {
                        var result = Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddPromoCode()));
                        result.then((value) {
                          // Print a message after the dialog is dismissed
                          fetchMyPromoCodes();
                        });
                        // print(result);
                        // if (result != null) {
                        // }
                      },
                      child: const Text(
                        "Add Promo-Code",
                        style: TextStyle(color: AppColors.bg1),
                      )),
                ),
              ],
            ),
            !loading && myPromocodes.isEmpty
                ? SizedBox(
                    height: sHeight * 0.9,
                    child: Column(
                      children: [
                        Center(
                          child: Center(child: Text('No Promo-codes found.')),
                        ),
                      ],
                    ),
                  )
                : loading && myPromocodes.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.colorPrimaryDark,
                        ),
                      )
                    : SizedBox(
                        height: sHeight * 0.8,
                        child: ListView.separated(
                          itemCount: myPromocodes.length,
                          separatorBuilder: (_, __) => const SizedBox(
                            height: 14,
                          ),
                          itemBuilder: (BuildContext context, int index) =>
                              GestureDetector(
                            onTap: () async {
                              if (myPromocodes[index].status.toLowerCase() !=
                                  "canceled") {
                                var result = showDialog(
                                    context: context,
                                    builder: (context) {
                                      return EditPromoCodeDialog(
                                        promoCodeDescription:
                                            myPromocodes[index]
                                                .promoCodeDescription,
                                        code: myPromocodes[index].code,
                                        productId:
                                            myPromocodes[index].productId,
                                        subProductId:
                                            myPromocodes[index].subProductId,
                                        endDate: myPromocodes[index].endDate,
                                        startDate:
                                            myPromocodes[index].startDate,
                                        discountAmount:
                                            myPromocodes[index].discountAmount,
                                        id: myPromocodes[index].id,
                                      );
                                    });
                                result.then((value) {
                                  // Print a message after the dialog is dismissed
                                  fetchMyPromoCodes();
                                });
                              }
                              // print("object");
                              // print(result);
                            },
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            myPromocodes[index].code,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          Text(myPromocodes[index].discountType)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            myPromocodes[index].discountAmount,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          Text(
                                            myPromocodes[index]
                                                        .status
                                                        .toString() ==
                                                    "PENDING_WAREHOUSE_APPROVAL"
                                                ? "PENDING"
                                                : myPromocodes[index].status,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                      myPromocodes[index].promoCodeDescription),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Start: ${DateFormat('dd MMM, yyyy').format(_parseDateString(myPromocodes[index].startDate))}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(),
                                      ),
                                      Text(
                                        "End: ${DateFormat('dd MMM, yyyy').format(_parseDateString(myPromocodes[index].endDate))}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            if (myPromocodes[index]
                                                    .status
                                                    .toLowerCase() !=
                                                "canceled") {
                                              var result = showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return PromoCodeDialog(
                                                      code: myPromocodes[index]
                                                          .code,
                                                    );
                                                  });
                                              result.then((value) {
                                                // Print a message after the dialog is dismissed
                                                fetchMyPromoCodes();
                                              });
                                            }
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            size: 20,
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  DateTime _parseDateString(String dateString) {
    try {
      // Parsing the ISO 8601 formatted date string
      return DateTime.parse(dateString);
    } catch (e) {
      // Handle parsing error, return current date as fallback
      print('Error parsing date: $e');
      return DateTime.now();
    }
  }

  Future<void> fetchMyPromoCodes() async {
    try {
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      print(isUserLoggedIn);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.get(
          Uri.https(
            "api.commercepal.com:2096",
            "/prime/api/v1/product/promo-codes/by-owner",
            {'owner': "MERCHANT"},
          ),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        print('hererererer');
        var datas = jsonDecode(response.body);
        print(datas);
        myPromocodes.clear();
        if (datas['statusCode'] == "000") {
          for (var i in datas['data']) {
            myPromocodes.add(PromoCodes(
              id: i['id'].toString(),
              merchantId: i['merchantId'].toString(),
              code: i['code'].toString(),
              productId: i['productId'].toString(),
              discountAmount: i['discountAmount'].toString(),
              discountType: i['discountType'].toString(),
              startDate: i['startDate'].toString(),
              endDate: i['endDate'].toString(),
              status: i['promoCodeStatus'].toString(),
              subProductId: i['subProductId'].toString(),
              promoCodeStatus: i['promoCodeStatus'].toString(),
              promoCodeDescription: i['promoCodeDescription'].toString(),
            ));
          }
          // if (myBids.isEmpty) {
          //   throw 'No special orders found';
          // }
          print(myPromocodes.length);
        } else {
          throw datas['statusDescription'] ?? 'Error fetching Promo-Codes';
        }
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
      rethrow;
    }
  }
}
