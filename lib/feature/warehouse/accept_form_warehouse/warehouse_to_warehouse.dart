import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/routes.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/login/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WarehouseToWarehouse extends StatefulWidget {
  final String userName;

  WarehouseToWarehouse({Key? key, required this.userName}) : super(key: key);

  @override
  State<WarehouseToWarehouse> createState() => _WarehouseToWarehouseState();
}

class ItemsDataFromWarehouse {
  final String UnitPrice;
  final String SubOrderNumber;
  final String ItemId;
  final String QrCodeNumber;
  final String OrderId;
  final String TotalAmount;
  final String ProductId;
  final String SubProductId;
  final String CreatedDate;
  ItemsDataFromWarehouse(
      {required this.UnitPrice,
      required this.SubOrderNumber,
      required this.ItemId,
      required this.QrCodeNumber,
      required this.OrderId,
      required this.TotalAmount,
      required this.ProductId,
      required this.CreatedDate,
      required this.SubProductId});
}

class _WarehouseToWarehouseState extends State<WarehouseToWarehouse> {
  List<ItemsDataFromWarehouse> deliveryOrders = [];
  var loading = false;
  @override
  void initState() {
    super.initState();
    fetchOrders();
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
                        // GestureDetector(
                        //   onTap: () async {
                        //     bool change = await showDialog(
                        //       context: context,
                        //       builder: (BuildContext context) {
                        //         return AlertDialog(
                        //           title: const Text('Change role'),
                        //           content: const Text(
                        //               'Do you want to change this role?'),
                        //           actions: <Widget>[
                        //             TextButton(
                        //               onPressed: () {
                        //                 Navigator.of(context).pop(
                        //                     false); // User does not confirm deletion
                        //               },
                        //               child: const Text('Cancel'),
                        //             ),
                        //             TextButton(
                        //               onPressed: () {
                        //                 Navigator.of(context).pop(
                        //                     true); // User confirms deletion
                        //               },
                        //               child: const Text('Yes'),
                        //             ),
                        //           ],
                        //         );
                        //       },
                        //     );
                        //     if (change) {
                        //       Navigator.pop(context);
                        //     }
                        //   },
                        //   child: Icon(
                        //     Icons.change_circle_outlined,
                        //     color: AppColors.textColor,
                        //     size: sWidth * 0.08,
                        //   ),
                        // )
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
                            child: Center(child: Text('${widget.userName[0]}')),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  widget.userName,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Accept Item',
                style: TextStyle(
                    fontSize: sWidth * 0.06,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> fetchOrders({int retryCount = 0}) async {
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
              "pay.commercepal.com",
              "/prime/api/v1/ware-house/shipping/orderItems",
              {'recipientWarehouseId': "2", "sortDirection": "desc"}),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        print(data);
        if (data['statusCode'] == '000') {
          setState(() {
            deliveryOrders.clear();
            for (var delivery in data['orderItems']) {
              // if (delivery['DeliveryType'] == 'MW') {
              deliveryOrders.add(ItemsDataFromWarehouse(
                  SubOrderNumber: delivery['SubOrderNumber'].toString(),
                  QrCodeNumber: delivery['QrCodeNumber'].toString(),
                  ItemId: delivery['ItemId'].toString(),
                  OrderId: delivery['OrderId'].toString(),
                  TotalAmount: delivery['TotalAmount'].toString(),
                  ProductId: delivery['ProductId'].toString(),
                  SubProductId: delivery['SubProductId'].toString(),
                  CreatedDate: delivery['CreatedDate'].toString(),
                  UnitPrice: delivery['UnitPrice'].toString()));
              // }
            }
            deliveryOrders.sort((b, a) {
              DateTime dateA = DateTime.parse(a.CreatedDate);
              DateTime dateB = DateTime.parse(b.CreatedDate);
              return dateA.compareTo(dateB);
            });
            loading = false;
          });
        } else {
          setState(() {
            loading = false;
          });
        }
      }

      print(deliveryOrders.length);
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
      // Handle other exceptions
    }
  }
}
