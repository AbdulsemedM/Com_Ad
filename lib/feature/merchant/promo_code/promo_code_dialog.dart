import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/dialog_utils.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
// import 'package:commercepal_admin_flutter/feature/special_order/special_orders.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PromoCodeDialog extends StatefulWidget {
  // final AssignedSpecialOrders myOrder;
  final String code;
  const PromoCodeDialog({super.key, required this.code});
  @override
  _PromoCodeDialogState createState() => _PromoCodeDialogState();
}

class _PromoCodeDialogState extends State<PromoCodeDialog> {
  var loading = false;
  // TextEditingController fullNameController = TextEditingController();
  // TextEditingController phoneNumberController = TextEditingController();
  // TextEditingController dateController = TextEditingController();
  // String selectedDate = "";
  var loading1 = false;
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    // dateController.text = DateFormat('yyyy-MM-dd')
    //     .format(DateTime.parse(selectedDate.toString()));
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2101),
  //   );
  //   print(picked != null);
  //   if (picked != null) {
  //     setState(() {
  //       selectedDate = picked;
  //       dateController.text = DateFormat('yyyy-MM-dd')
  //           .format(DateTime.parse(selectedDate.toString()));
  //       print(selectedDate);
  //     });
  //   }
  // }

  // String? _validateField(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'This field is required';
  //   }
  //   return null;
  // }

  // String? _validateDate(DateTime? value) {
  //   if (value == null) {
  //     return 'This field is required';
  //   }
  //   return null;
  // }

  // final GlobalKey<FormState> _myForm = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete a PromoCode'),
      // content: Text("${selectedDate.toLocal()}".split(' ')[0]),
      actions: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: [
              Text("Do you want to delete ${widget.code} promocode?"),
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      // final body = {
                      //   "bidId": int.parse(widget.bidId),
                      //   "isMerchantAccepted": 1,
                      //   "offerDetails": fullNameController.text,
                      //   "offerPrice": int.parse(phoneNumberController.text),
                      //   "offerExpireDate": dateController.text
                      // };
                      // print(body);
                      try {
                        final prefsData = getIt<PrefsData>();
                        final isUserLoggedIn =
                            await prefsData.contains(PrefsKeys.userToken.name);
                        if (isUserLoggedIn) {
                          final token = await prefsData
                              .readData(PrefsKeys.userToken.name);
                          final body = {
                            "owner": "MERCHANT",
                            "code": widget.code
                          };
                          final response = await http.put(
                              Uri.https(
                                  "api.commercepal.com:2096",
                                  "prime/api/v1/product/promo-codes/cancel",
                                  {"code": widget.code, "owner": "MERCHANT"}),
                              // body: jsonEncode(body),
                              headers: <String, String>{
                                "Authorization": "Bearer $token",
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                              },
                              body: jsonEncode(body));
                          // print(response.body);
                          var data = jsonDecode(response.body);
                          print(data);

                          if (data['statusCode'] == '000') {
                            displaySnack(
                                context, "Promo-Code canceled successfully.");
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
                        'Something went wrong. ';
                        displaySnack(context, message);
                      } finally {
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                    child: loading
                        ? const CircularProgressIndicator(
                            color: AppColors.colorPrimaryDark,
                          )
                        : Text(
                            'Yes',
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
