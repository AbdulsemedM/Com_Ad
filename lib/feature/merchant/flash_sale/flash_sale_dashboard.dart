import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
            "/api/v1/product/flash-sales/merchant",
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
              status: i['promoCodeStatus'].toString(),
              flashSaleMinQuantityPerCustomer:
                  i['flashSaleMinQuantityPerCustomer'].toString(),
              flashSaleTotalQuantitySold:
                  i['flashSaleTotalQuantitySold'].toString(),
            ));
          }
          // if (myBids.isEmpty) {
          //   throw 'No special orders found';
          // }
          print(myFlashSales.length);
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
