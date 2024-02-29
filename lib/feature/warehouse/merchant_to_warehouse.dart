import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/routes.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/login/presentation/login_page.dart';
import 'package:commercepal_admin_flutter/feature/messenger/order_items/order_items.dart';
import 'package:commercepal_admin_flutter/feature/warehouse/accept_merchant_to_warehouse_order.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MerchantToWarehouse extends StatefulWidget {
  final String userName;
  const MerchantToWarehouse({Key? key, required this.userName})
      : super(key: key);

  @override
  State<MerchantToWarehouse> createState() => _MerchantToWarehouseState();
}

class _MerchantToWarehouseState extends State<MerchantToWarehouse> {
  List<DeliveryData> deliveryOrders = [];
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
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Accept Order',
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
          loading
              ? Center(child: CircularProgressIndicator())
              : SizedBox(
                  height: sHeight * 0.65,
                  child: ListView.builder(
                      itemCount: deliveryOrders.length,
                      itemBuilder: (BuildContext, index) {
                        return GestureDetector(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AcceptMTWOrder(
                                        ItemOrderId:
                                            deliveryOrders[index].ItemOrderId,
                                        userName: widget.userName)));
                          },
                          child: Card(
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
                                      child: Text(
                                          "Item Order Id: ${deliveryOrders[index].ItemOrderId}"),
                                    ),
                                    Text(deliveryOrders[index].ItemOrderRef,
                                        style:
                                            TextStyle(fontSize: sWidth * 0.03)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                          deliveryOrders[index].DeliveryType,
                                          style: TextStyle(
                                              fontSize: sWidth * 0.02)),
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
                                Text(
                                    DateFormat('dd MMM, HH:mm').format(
                                        DateTime.parse(deliveryOrders[index]
                                            .AssignedDate)),
                                    style: TextStyle(fontSize: sWidth * 0.03))
                              ],
                            ),
                          ),
                        );
                      }),
                )
        ]),
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
              "api.commercepal.com:2095",
              "/prime/api/v1/messenger/shipping/deliveries",
              {'status': "1", "deliveryStatus": "1"}),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        print(data);
        if (data['statusCode'] == '000') {
          setState(() {
            deliveryOrders.clear();
            for (var delivery in data['deliveryList']) {
              if (delivery['DeliveryType'] == 'MW') {
                deliveryOrders.add(DeliveryData(
                    ItemOrderId: delivery['ItemOrderId'].toString(),
                    DeliveryId: delivery['DeliveryId'].toString(),
                    DeliveryType: delivery['DeliveryType'].toString(),
                    CustomerId: delivery['CustomerId'].toString(),
                    ItemOrderRef: delivery['ItemOrderRef'].toString(),
                    MerchantId: delivery['MerchantId'].toString(),
                    DeliveryStatus: delivery['DeliveryStatus'].toString(),
                    ValidationStatus: delivery['ValidationStatus'].toString(),
                    AssignedDate: delivery['AssignedDate']));
              }
            }
            deliveryOrders.sort((b, a) {
              DateTime dateA = DateTime.parse(a.AssignedDate);
              DateTime dateB = DateTime.parse(b.AssignedDate);
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
