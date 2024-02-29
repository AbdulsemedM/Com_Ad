import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/routes.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/login/presentation/login_page.dart';
import 'package:commercepal_admin_flutter/feature/messenger/order_items/item_details.dart';
import 'package:commercepal_admin_flutter/feature/messenger/order_management/accepted_orders.dart';
import 'package:commercepal_admin_flutter/feature/messenger/order_management/collected_orderss.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MessengerOrderItems extends StatefulWidget {
  final String orederType;
  final String userName;
  const MessengerOrderItems(
      {Key? key, required this.orederType, required this.userName})
      : super(key: key);

  @override
  State<MessengerOrderItems> createState() => _MessengerOrderItemsState();
}

class DeliveryData {
  final ItemOrderId;
  final String DeliveryId;
  final String DeliveryStatus;
  final String MerchantId;
  final String ItemOrderRef;
  final String CustomerId;
  final String DeliveryType;
  final String AssignedDate;
  final String ValidationStatus;
  DeliveryData(
      {required this.ItemOrderId,
      required this.DeliveryId,
      required this.DeliveryType,
      required this.CustomerId,
      required this.ItemOrderRef,
      required this.MerchantId,
      required this.DeliveryStatus,
      required this.ValidationStatus,
      required this.AssignedDate});
}

class _MessengerOrderItemsState extends State<MessengerOrderItems> {
  void initState() {
    super.initState();
    fetchOrders(type: widget.orederType.toString());
  }

  List<DeliveryData> deliveryOrders = [];
  var loading = false;
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
                              "Messenger",
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
                          //     color: AppColors.bgCreamWhite,
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
                                        "Messenger",
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
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : loading == false && deliveryOrders.isEmpty
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
                          child: Text(
                              "Currently there is no delivery asigned to you."),
                        ),
                      ],
                    ),
                  ))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.orederType == 'Open Orders'
                                ? "Open Orders"
                                : widget.orederType == 'Accepted Orders'
                                    ? "Accepted Orders"
                                    : widget.orederType == 'Collected Orders'
                                        ? "Collected Orders"
                                        : 'Delivered Orders',
                            style: TextStyle(
                                fontSize: sWidth * 0.06,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Divider(),
                        ),
                        SizedBox(
                          height: sHeight * 0.65,
                          child: ListView.builder(
                              itemCount: deliveryOrders.length,
                              itemBuilder: (BuildContext, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    if (widget.orederType == 'Open Orders') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OrdererdItemDetails(
                                                    ItemId:
                                                        deliveryOrders[index]
                                                            .ItemOrderId,
                                                    DeliveryId:
                                                        deliveryOrders[index]
                                                            .DeliveryId,
                                                    userName: widget.userName,
                                                  )));
                                    }
                                    if (widget.orederType ==
                                        'Accepted Orders') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AcceptedOrder(
                                                    ItemId:
                                                        deliveryOrders[index]
                                                            .ItemOrderId,
                                                    DeliveryId:
                                                        deliveryOrders[index]
                                                            .DeliveryId,
                                                    userName: widget.userName,
                                                  )));
                                    }
                                    if (widget.orederType ==
                                            'Collected Orders' &&
                                        deliveryOrders[index].DeliveryType ==
                                            "MC") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CollectedOrders(
                                                    ItemId:
                                                        deliveryOrders[index]
                                                            .ItemOrderId,
                                                    DeliveryId:
                                                        deliveryOrders[index]
                                                            .DeliveryId,
                                                    userName: widget.userName,
                                                  )));
                                    }
                                    if (widget.orederType ==
                                            'Collected Orders' &&
                                        deliveryOrders[index].DeliveryType ==
                                            "MW") {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title:
                                              const Text('Order Comfirmation'),
                                          content: const Text(
                                              'Show the QRCode to the warehouse agent.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context); // Close the dialog
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    if (widget.orederType ==
                                        'Delivered Orders') {
                                      // Show a dialog indicating the order has been delivered
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Order Delivered'),
                                          content: const Text(
                                              'The order has been successfully delivered.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context); // Close the dialog
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  child: Card(
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                  "Item Order Id: ${deliveryOrders[index].ItemOrderId}"),
                                            ),
                                            Text(
                                                deliveryOrders[index]
                                                    .ItemOrderRef,
                                                style: TextStyle(
                                                    fontSize: sWidth * 0.03)),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                  deliveryOrders[index]
                                                      .DeliveryType,
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
                                                DateTime.parse(
                                                    deliveryOrders[index]
                                                        .AssignedDate)),
                                            style: TextStyle(
                                                fontSize: sWidth * 0.03))
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ));
  }

  Future<void> fetchOrders({int retryCount = 0, required String type}) async {
    try {
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);

        if (widget.orederType == 'Open Orders') {
          final response = await http.get(
            Uri.https(
                "api.commercepal.com:2095",
                "/prime/api/v1/messenger/shipping/deliveries",
                {'status': "0", "deliveryStatus": "0"}),
            headers: <String, String>{"Authorization": "Bearer $token"},
          );

          var data = jsonDecode(response.body);
          print(data);
          if (data['statusCode'] == '000') {
            setState(() {
              deliveryOrders.clear();
              for (var delivery in data['deliveryList']) {
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
        } else if (widget.orederType == 'Accepted Orders') {
          final response = await http.get(
            Uri.https(
                "api.commercepal.com:2095",
                "/prime/api/v1/messenger/shipping/deliveries",
                {'status': "1", "deliveryStatus": "0"}),
            headers: <String, String>{"Authorization": "Bearer $token"},
          );

          var data = jsonDecode(response.body);
          print(data);
          if (data['statusCode'] == '000') {
            setState(() {
              deliveryOrders.clear();
              for (var delivery in data['deliveryList']) {
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
        } else if (widget.orederType == 'Collected Orders') {
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
        } else if (widget.orederType == 'Delivered Orders') {
          final response = await http.get(
            Uri.https(
                "api.commercepal.com:2095",
                "/prime/api/v1/messenger/shipping/deliveries",
                {'status': "1", "deliveryStatus": "3"}),
            headers: <String, String>{"Authorization": "Bearer $token"},
          );

          var data = jsonDecode(response.body);
          print(data);
          if (data['statusCode'] == '000') {
            setState(() {
              deliveryOrders.clear();
              for (var delivery in data['deliveryList']) {
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
        } else {
          // Retry limit reached, handle accordingly
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
