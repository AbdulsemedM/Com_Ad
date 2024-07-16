import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/routes.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/login/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OrdersToReceive extends StatefulWidget {
  final String userName;
  const OrdersToReceive({Key? key, required this.userName}) : super(key: key);

  @override
  State<OrdersToReceive> createState() => _OrdersToReceiveState();
}

class ReceivedOrders {
  final String StatusDescription;
  final String TotalPrice;
  final String OrderRef;
  final String OrderDate;
  ReceivedOrders(
      {required this.StatusDescription,
      required this.OrderRef,
      required this.TotalPrice,
      required this.OrderDate});
}

class _OrdersToReceiveState extends State<OrdersToReceive> {
  List<ReceivedOrders> orders = [];
  var loading = false;
  @override
  void initState() {
    super.initState();
    fetchOrderData();
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
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: AppColors.bgCreamWhite,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Agent",
                              style: TextStyle(
                                  fontSize: sWidth * 0.06,
                                  color: AppColors.bgCreamWhite,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 20,
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
                              child:
                                  Center(child: Text('${widget.userName[0]}')),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
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
                                        "Agent",
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
                              onPressed: () async {
                                final prefsData = getIt<PrefsData>();
                                await prefsData
                                    .deleteData(PrefsKeys.userToken.name);
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
        body: SingleChildScrollView(
            child: loading == false && orders.isNotEmpty
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Text(
                              "Orders to be received",
                              style: TextStyle(fontSize: sWidth * 0.04),
                            )
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: SizedBox(
                          height: sHeight * 0.65,
                          child: ListView.builder(
                              itemCount: orders.length,
                              itemBuilder: (BuildContext, index) {
                                return Card(
                                  shadowColor: AppColors.colorAccent,
                                  elevation: 2,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                                "Order ref: ${orders[index].OrderRef}"),
                                          ),
                                          Text(orders[index].TotalPrice,
                                              style: TextStyle(
                                                  fontSize: sWidth * 0.03)),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                                orders[index].StatusDescription,
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
                                          DateFormat('dd MMM yyyy, HH:mm')
                                              .format(DateTime.parse(
                                                  orders[index].OrderDate)),
                                          style: TextStyle(
                                              fontSize: sWidth * 0.03))
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  )
                : loading == false && orders.isEmpty
                    ? Center(
                        child: SizedBox(
                        // height: sHeight * 0.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                                height: sHeight * 0.4,
                                image: const AssetImage(
                                    "assets/images/mobile_user.png")),
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
                        : Container()));
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
            "/prime/api/v1/agent/order/order-summary",
          ),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        Map<String, dynamic> data = json.decode(response.body);
        print(data);

        print(data['statusCode']);
        if (data['statusCode'] == '000') {
          setState(() {
            for (var datas in data['details']) {
              orders.add(ReceivedOrders(
                StatusDescription: datas['StatusDescription'],
                OrderRef: datas['OrderRef'],
                TotalPrice: datas['TotalPrice'],
                OrderDate: datas['OrderDate'],
              ));
            }
            loading = false;
          });
          print("hey merchant");
          print(orders.length);
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
