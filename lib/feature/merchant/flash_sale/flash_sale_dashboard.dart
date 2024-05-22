import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/merchant/flash_sale/add_flash_sale.dart';
import 'package:commercepal_admin_flutter/feature/merchant/flash_sale/edit_flashsale_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FlashSaleDashboard extends StatefulWidget {
  const FlashSaleDashboard({super.key});

  @override
  State<FlashSaleDashboard> createState() => _FlashSaleDashboardState();
}

class FlashSales {
  final String id;
  final String flashSaleStartDate;
  final String flashSaleEndDate;
  final String flashSaleMinQuantityPerCustomer;
  final String flashSaleTotalQuantitySold;
  final String productName;
  final String merchantId;
  final String flashSalePrice;
  final String flashSaleInventoryQuantity;
  final String flashSaleMaxQuantityPerCustomer;
  final String status;
  final String isQuantityRestrictedPerCustomer;
  FlashSales(
      {required this.id,
      required this.flashSaleStartDate,
      required this.flashSaleEndDate,
      required this.flashSaleMinQuantityPerCustomer,
      required this.flashSaleTotalQuantitySold,
      required this.productName,
      required this.merchantId,
      required this.flashSalePrice,
      required this.flashSaleInventoryQuantity,
      required this.status,
      required this.isQuantityRestrictedPerCustomer,
      required this.flashSaleMaxQuantityPerCustomer});
}

class _FlashSaleDashboardState extends State<FlashSaleDashboard> {
  var loading = false;
  List<FlashSales> myFlashSales = [];
  @override
  void initState() {
    super.initState();
    fetchMyFlashSales();
  }

  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height;
    return Scaffold(
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
                                builder: (context) => const AddFlashSale()));
                        result.then((value) {
                          // Print a message after the dialog is dismissed
                          fetchMyFlashSales();
                        });
                        print(result);
                        if (result != null) {}
                      },
                      child: const Text(
                        "Add Flash-Sales",
                        style: TextStyle(color: AppColors.bg1),
                      )),
                ),
              ],
            ),
            !loading && myFlashSales.isEmpty
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
                : loading && myFlashSales.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.colorPrimaryDark,
                        ),
                      )
                    : SizedBox(
                        height: sHeight * 0.8,
                        child: ListView.separated(
                          itemCount: myFlashSales.length,
                          separatorBuilder: (_, __) => const SizedBox(
                            height: 14,
                          ),
                          itemBuilder: (BuildContext context, int index) =>
                              GestureDetector(
                            onTap: () async {
                              if (myFlashSales[index].status.toLowerCase() !=
                                      "canceled" &&
                                  myFlashSales[index].status.toLowerCase() !=
                                      "active") {
                                var result = showDialog(
                                    context: context,
                                    builder: (context) {
                                      return EditFlashSaleDialog(
                                        flashSalePrice:
                                            myFlashSales[index].flashSalePrice,
                                        flashSaleInventoryQuantity:
                                            myFlashSales[index]
                                                .flashSaleInventoryQuantity,
                                        isQuantityRestrictionPerCustomer:
                                            myFlashSales[index]
                                                .isQuantityRestrictedPerCustomer,
                                        flashSaleEndDate: myFlashSales[index]
                                            .flashSaleEndDate,
                                        flashSaleStartDate: myFlashSales[index]
                                            .flashSaleStartDate,
                                        flashSaleMinQuantityPerCustomer:
                                            myFlashSales[index]
                                                .flashSaleMinQuantityPerCustomer,
                                        flashSaleMaxQuantityPerCustomer:
                                            myFlashSales[index]
                                                .flashSaleMaxQuantityPerCustomer,
                                        id: myFlashSales[index].id,
                                        productName:
                                            myFlashSales[index].productName,
                                      );
                                    });
                                result.then((value) {
                                  // Print a message after the dialog is dismissed
                                  fetchMyFlashSales();
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
                                          Row(
                                            children: [
                                              Text("Prod. "),
                                              Text(
                                                myFlashSales[index].productName,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Flash Pr. "),
                                              Text(
                                                  "${myFlashSales[index].flashSalePrice} ETB"),
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text("Tot. Sold "),
                                              Text(
                                                myFlashSales[index]
                                                    .flashSaleTotalQuantitySold,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Status "),
                                              Text(
                                                myFlashSales[index].status,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text("Min. Quant "),
                                              Text(
                                                myFlashSales[index]
                                                    .flashSaleMinQuantityPerCustomer,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Max. Quant "),
                                              Text(
                                                myFlashSales[index]
                                                    .flashSaleMaxQuantityPerCustomer,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Start: ${DateFormat('dd MMM, yyyy').format(_parseDateString(myFlashSales[index].flashSaleStartDate))}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(),
                                      ),
                                      Text(
                                        "End: ${DateFormat('dd MMM, yyyy').format(_parseDateString(myFlashSales[index].flashSaleEndDate))}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            if (myFlashSales[index]
                                                    .status
                                                    .toLowerCase() !=
                                                "canceled") {
                                              // var result = showDialog(
                                              //     context: context,
                                              //     builder: (context) {
                                              //       return PromoCodeDialog(
                                              //         code: myFlashSales[index]
                                              //             .code,
                                              //       );
                                              //     });
                                              // result.then((value) {
                                              //   // Print a message after the dialog is dismissed
                                              //   fetchMyFlashSales();
                                              // });
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

  Future<void> fetchMyFlashSales() async {
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
            "/prime/api/v1/product/flash-sales/merchant",
            {'page': "0", "size": "100", "sortDirection": "desc"},
          ),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        print('hererererer');
        var datas = jsonDecode(response.body);
        print(datas);
        myFlashSales.clear();
        if (datas['statusCode'] == "000") {
          for (var i in datas['data']['flashSales']) {
            myFlashSales.add(FlashSales(
              id: i['id'].toString(),
              merchantId: i['merchantId'].toString(),
              flashSaleMaxQuantityPerCustomer:
                  i['flashSaleMaxQuantityPerCustomer'].toString(),
              flashSaleInventoryQuantity:
                  i['flashSaleInventoryQuantity'].toString(),
              flashSalePrice: i['flashSalePrice'].toString(),
              productName: i['productName'].toString(),
              flashSaleStartDate: i['flashSaleStartDate'].toString(),
              flashSaleEndDate: i['flashSaleEndDate'].toString(),
              status: i['status'].toString(),
              flashSaleMinQuantityPerCustomer:
                  i['flashSaleMinQuantityPerCustomer'].toString(),
              flashSaleTotalQuantitySold:
                  i['flashSaleTotalQuantitySold'].toString(),
              isQuantityRestrictedPerCustomer:
                  'isQuantityRestrictedPerCustomer',
            ));
          }
          // if (myBids.isEmpty) {
          //   throw 'No special orders found';
          // }
          print(myFlashSales.length);
        } else {
          throw datas['statusDescription'] ?? 'Error fetching Flash-Sales';
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
