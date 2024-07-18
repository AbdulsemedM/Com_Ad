import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/dialog_utils.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/merchant/special_order/my_dialog.dart';
// import 'package:commercepal_admin_flutter/feature/special_order/my_dialog.dart';
// import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SpecialOrders extends StatefulWidget {
  const SpecialOrders({super.key});

  @override
  State<SpecialOrders> createState() => _SpecialOrdersState();
}

class AssignedSpecialOrders {
  final String assignedDate;
  final String merchantId;
  final String specialOrderId;
  final String bidId;
  final String quantity;
  final String productName;
  final String estimatePrice;
  final String linkToProduct;
  final String imageOne;
  final String productDescription;
  AssignedSpecialOrders(
      {required this.assignedDate,
      required this.merchantId,
      required this.bidId,
      required this.quantity,
      required this.productName,
      required this.estimatePrice,
      required this.linkToProduct,
      required this.imageOne,
      required this.productDescription,
      required this.specialOrderId});
}

class _SpecialOrdersState extends State<SpecialOrders> {
  List<AssignedSpecialOrders> myBids = [];
  var loading = false;
  @override
  void initState() {
    super.initState();
    fetchSpecialBids();
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Special Orders",
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      )),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: sHeight * 0.9,
              child: !loading && myBids.isEmpty
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Center(child: Text("No bids found"))],
                    )
                  : loading && myBids.isEmpty
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: CircularProgressIndicator(
                                color: AppColors.colorPrimaryDark,
                              ),
                            ),
                            Text("Fetching special orders")
                          ],
                        )
                      : SizedBox(
                          height: sHeight * 0.5,
                          child: ListView.builder(
                              itemCount: myBids.length,
                              itemBuilder: (BuildContext, index) {
                                return GestureDetector(
                                  onTap: () {
                                    var result = showDialog(
                                        context: context,
                                        builder: (context) {
                                          return MyDialog(
                                            bidId: myBids[index].bidId,
                                            myOrder: myBids[index],
                                          );
                                        });
                                    // ignore: unnecessary_null_comparison
                                    if (result != null) {
                                      fetchSpecialBids();
                                    }
                                    // editModal(myBids[index]);
                                  },
                                  child: Card(
                                    shadowColor: AppColors.colorAccent,
                                    elevation: 2,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(myBids[index].productName),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      "Estimated Price ${myBids[index].estimatePrice}",
                                                      style: TextStyle(
                                                          fontSize:
                                                              sWidth * 0.03)),
                                                ),
                                                // Text(myBids[index].quantity,
                                                //     style: TextStyle(
                                                //         fontSize:
                                                //             sWidth * 0.03)),
                                              ],
                                            ),
                                            Text(
                                                "Quantity: ${myBids[index].quantity}",
                                                style: TextStyle(
                                                    fontSize: sWidth * 0.03)),
                                          ],
                                        ),
                                        Text(myBids[index].productDescription),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Divider(
                                            thickness: sHeight * 0.001,
                                          ),
                                        ),
                                        Text(
                                            DateFormat('dd MMM yyyy').format(
                                                DateTime.parse(myBids[index]
                                                    .assignedDate)),
                                            style: TextStyle(
                                                fontSize: sWidth * 0.04,
                                                color: AppColors.purple)),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
            )
          ],
        ),
      )),
    );
  }

  void editModal(AssignedSpecialOrders allBids) {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    // String selectedDate = "";
    // var loading1 = false;
    DateTime selectedDate = DateTime.now();
    dateController.text = DateFormat('dd MMM yyyy')
        .format(DateTime.parse(selectedDate.toString()));

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );

      print(picked != null && picked != selectedDate);
      if (picked != null) {
        setState(() {
          dateController.text = DateFormat('dd MMM yyyy')
              .format(DateTime.parse(selectedDate.toString()));
          selectedDate = picked;
          print(selectedDate);
        });
      }
    }

    String? _validateField(String? value) {
      if (value == null || value.isEmpty) {
        return 'This field is required';
      }
      return null;
    }

    String? _validateDate(DateTime? value) {
      if (value == null) {
        return 'This field is required';
      }
      return null;
    }

    showDialog(
      context: context, // Pass the BuildContext to showDialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Accept Bid'), // Set your dialog title
          content: const Text('Do you want to accept this bid?'),
          // content: Text(allMember.fullName), // Set your dialog content
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 2, 0, 8),
              child: TextFormField(
                validator: _validateField,
                controller: fullNameController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: AppColors.colorPrimaryDark),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: AppColors.colorPrimaryDark),
                  ),
                  labelText: "Offer details",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                keyboardType: TextInputType.number,
                validator: _validateField,
                controller: phoneNumberController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: AppColors.colorPrimaryDark),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: AppColors.colorPrimaryDark),
                  ),
                  labelText: "Offer proce",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                readOnly: true,
                keyboardType: TextInputType.number,
                validator: _validateField,
                controller: dateController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: AppColors.colorPrimaryDark),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: AppColors.colorPrimaryDark),
                  ),
                  labelText: "Offer Expiry date",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text("Delivery Date"),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Text(DateFormat('dd MMM yyyy')
                            .format(DateTime.parse(selectedDate.toString()))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 200,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Change date'),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    if (fullNameController.text.isEmpty) {
                      displaySnack(context, "This field is mandatory");
                    } else if (phoneNumberController.text.isEmpty) {
                      displaySnack(context, "Offer price is mandatory");
                    } else {
                      setState(() {
                        loading = true;
                      });
                      final body = {
                        "bidId": int.parse(allBids.bidId),
                        // "specialOrderId": int.parse(widget.specialOrderId),
                        "isMerchantAccepted": 1,
                        "offerDetails": fullNameController.text,
                        "offerPrice": int.parse(phoneNumberController.text),
                        "offerExpireDate": selectedDate
                      };
                      print(body);
                      try {
                        final prefsData = getIt<PrefsData>();
                        final isUserLoggedIn =
                            await prefsData.contains(PrefsKeys.userToken.name);
                        if (isUserLoggedIn) {
                          final token = await prefsData
                              .readData(PrefsKeys.userToken.name);
                          final response = await http.post(
                              Uri.https("api.commercepal.com:2096",
                                  "prime/api/v1/special-orders/bid/respond-by-customer"),
                              body: jsonEncode(body),
                              headers: <String, String>{
                                "Authorization": "Bearer $token"
                              });
                          // print(response.body);
                          var data = jsonDecode(response.body);
                          print(data);

                          if (data['statusCode'] == '000') {
                            Navigator.pop(context);
                            fetchSpecialBids();
                            setState(() {
                              loading = false;
                            });
                            // return true;
                          } else {
                            setState(() {
                              loading = false;
                            });
                          }
                        }
                      } catch (e) {
                        var message = e.toString();
                        'Please check your network connection';
                        displaySnack(context, message);
                      } finally {
                        setState(() {
                          loading = false;
                        });
                      }
                    }
                  },
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Colors.orange,
                        )
                      : Text(
                          'Accept',
                        ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"))
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchSpecialBids() async {
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
            "/prime/api/v1/special-orders/bids/merchant/assigned-to-me",
            // {'specialProductOrderId': widget.specialOrderId},
          ),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        print('hererererer');
        var datas = jsonDecode(response.body);
        print(datas);
        myBids.clear();
        if (datas['statusCode'] == "000") {
          for (var i in datas['data']) {
            if (i['status'] != 3) {
              myBids.add(AssignedSpecialOrders(
                assignedDate: i['assignedDate'].toString(),
                merchantId: i['merchantId'].toString(),
                specialOrderId: i['specialOrderId'].toString(),
                bidId: i['bidId'].toString(),
                quantity: i['quantity'].toString(),
                productName: i['productName'].toString(),
                estimatePrice: i['estimatePrice'].toString(),
                linkToProduct: i['linkToProduct'].toString(),
                imageOne: i['imageOne'].toString(),
                productDescription: i['productDescription'].toString() ?? '',
              ));
            }
          }
          // if (myBids.isEmpty) {
          //   throw 'No special orders found';
          // }
          print(myBids.length);
        } else {
          throw datas['statusDescription'] ?? 'Error fetching special orders';
        }
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
