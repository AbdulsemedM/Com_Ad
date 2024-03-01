import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/dialog_utils.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/merchant/special_order/special_orders.dart';
// import 'package:commercepal_admin_flutter/feature/special_order/special_orders.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MyDialog extends StatefulWidget {
  final AssignedSpecialOrders myOrder;
  final String bidId;
  const MyDialog({super.key, required this.bidId, required this.myOrder});
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  var loading = false;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  // String selectedDate = "";
  var loading1 = false;
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(selectedDate.toString()));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    print(picked != null);
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(selectedDate.toString()));
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

  final GlobalKey<FormState> _myForm = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Accept a special order'),
      // content: Text("${selectedDate.toLocal()}".split(' ')[0]),
      actions: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: Image(
                  image: NetworkImage(widget.myOrder.imageOne),
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      // Image is fully loaded
                      return child;
                    } else {
                      // Image is still loading, show a loading indicator
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    // Display a message when the image fails to load
                    return Text('Failed to load image');
                  },
                ),
              ),
              if (widget.myOrder.linkToProduct != "")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Text("To see more details "),
                      TextButton(
                          onPressed: () async {
                            launchUrl(widget.myOrder.linkToProduct);
                          },
                          child: Text("Click here")),
                    ],
                  ),
                ),
              Form(
                  key: _myForm,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 2, 0, 8),
                        child: TextFormField(
                          validator: _validateField,
                          controller: fullNameController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(
                                12.0, 10.0, 12.0, 10.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: AppColors.colorPrimaryDark),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: AppColors.colorPrimaryDark),
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
                            contentPadding: const EdgeInsets.fromLTRB(
                                12.0, 10.0, 12.0, 10.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: AppColors.colorPrimaryDark),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: AppColors.colorPrimaryDark),
                            ),
                            labelText: "Offer price",
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
                            contentPadding: const EdgeInsets.fromLTRB(
                                12.0, 10.0, 12.0, 10.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: AppColors.colorPrimaryDark),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: AppColors.colorPrimaryDark),
                            ),
                            labelText: "Offer Expiry date",
                          ),
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
                    ],
                  )),
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      if (!_myForm.currentState!.validate()) {
                      } else {
                        setState(() {
                          loading = true;
                        });
                        final body = {
                          "bidId": int.parse(widget.bidId),
                          "isMerchantAccepted": 1,
                          "offerDetails": fullNameController.text,
                          "offerPrice": int.parse(phoneNumberController.text),
                          "offerExpireDate": dateController.text
                        };
                        print(body);
                        try {
                          final prefsData = getIt<PrefsData>();
                          final isUserLoggedIn = await prefsData
                              .contains(PrefsKeys.userToken.name);
                          if (isUserLoggedIn) {
                            final token = await prefsData
                                .readData(PrefsKeys.userToken.name);
                            final response = await http.post(
                                Uri.https("api.commercepal.com:2096",
                                    "prime/api/v1/special-orders/bids/merchant/respond-to-assignment"),
                                body: jsonEncode(body),
                                headers: <String, String>{
                                  "Authorization": "Bearer $token"
                                });
                            // print(response.body);
                            var data = jsonDecode(response.body);
                            print(data);

                            if (data['statusCode'] == '000') {
                              displaySnack(context, "Bid placed successfully.");
                              Navigator.pop(context, true);
                              // fetchSpecialBids();
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
                        Navigator.pop(context, true);
                      },
                      child: Text("Cancel"))
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void launchUrl(String myUrl) async {
    String url = myUrl;
    try {
      // if (await canLaunch(url)) {
      await launch(url);
      // } else {
      // print("Could not launch $url");
      // }
    } catch (e) {
      displaySnack(context, "There was an error launching $url");
    }
  }
}
