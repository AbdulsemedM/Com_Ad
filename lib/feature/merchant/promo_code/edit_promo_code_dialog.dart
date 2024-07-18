import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/dialog_utils.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
// import 'package:commercepal_admin_flutter/feature/merchant/promo_code/promo_code_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class EditPromoCodeDialog extends StatefulWidget {
  final String productId;
  final String subProductId;
  final String startDate;
  final String endDate;
  final String code;
  final String id;
  final String discountAmount;
  final String promoCodeDescription;
  const EditPromoCodeDialog(
      {super.key,
      required this.productId,
      required this.endDate,
      required this.startDate,
      required this.code,
      required this.id,
      required this.discountAmount,
      required this.promoCodeDescription,
      required this.subProductId});
  @override
  _EditPromoCodeDialogState createState() => _EditPromoCodeDialogState();
}

class _EditPromoCodeDialogState extends State<EditPromoCodeDialog> {
  var loading = false;
  TextEditingController discountAmountController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var loading1 = false;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    startController.text = DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(widget.startDate.toString()));
    endController.text = DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(widget.endDate.toString()));
    codeController.text = widget.code.toString();
    discountAmountController.text = widget.discountAmount.toString();
    descriptionController.text = widget.promoCodeDescription.toString();
  }

  Future<void> _startDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    print(picked != null);
    if (picked != null) {
      setState(() {
        startDate = picked;
        startController.text = DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(startDate.toString()));
        print(startDate);
      });
    }
  }

  Future<void> _endDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    print(picked != null);
    if (picked != null) {
      setState(() {
        endDate = picked;
        endController.text =
            DateFormat('yyyy-MM-dd').format(DateTime.parse(endDate.toString()));
        print(endDate);
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
      title: Text(
        'Edit a Promo-code for ${widget.code}',
        style: TextStyle(fontSize: 15),
      ),
      actions: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: [
              Form(
                  key: _myForm,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 2, 0, 8),
                        child: TextFormField(
                          readOnly: true,
                          validator: _validateField,
                          controller: codeController,
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
                              labelText: "Code",
                              hintText: "Ex. Test promo code"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: _validateField,
                          controller: discountAmountController,
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
                            labelText: "Discount Amount (%)",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 2, 0, 8),
                        child: TextFormField(
                          validator: _validateField,
                          controller: descriptionController,
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
                              labelText: "Promo-code Description"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          validator: _validateField,
                          controller: startController,
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
                            labelText: "Start date",
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Row(
                      //     children: [
                      //       SizedBox(
                      //         width: 200,
                      //         height: 40,
                      //         child: ElevatedButton(
                      //           style: ElevatedButton.styleFrom(
                      //               backgroundColor:
                      //                   AppColors.colorPrimaryDark),
                      //           onPressed: () => _startDate(context),
                      //           child: Text('Change date',
                      //               style: TextStyle(color: Colors.white)),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          validator: _validateField,
                          controller: endController,
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
                            labelText: "End date",
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
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.colorPrimaryDark),
                                onPressed: () => _endDate(context),
                                child: Text('Change date',
                                    style: TextStyle(color: Colors.white)),
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
                      print(widget.subProductId);
                      if (!_myForm.currentState!.validate()) {
                        print(widget.subProductId);
                      } else {
                        setState(() {
                          loading = true;
                        });
                        print(widget.subProductId);
                        final body = {
                          // "owner": "MERCHANT",
                          "code": codeController.text,
                          // "productId": int.parse(widget.productId),
                          // "subProductId": int.parse(widget.subProductId),
                          // "discountType": "PERCENTAGE",
                          "promoCodeDescription": descriptionController.text,
                          "discountAmount":
                              int.parse(discountAmountController.text),
                          "startDate": "${startController.text} 12",
                          "endDate": "${endController.text} 12",
                          // "promoCodeDescription": "-"
                        };
                        print(body);
                        try {
                          final prefsData = getIt<PrefsData>();
                          final isUserLoggedIn = await prefsData
                              .contains(PrefsKeys.userToken.name);
                          if (isUserLoggedIn) {
                            final token = await prefsData
                                .readData(PrefsKeys.userToken.name);
                            final response = await http.put(
                                Uri.https(
                                  "api.commercepal.com:2096",
                                  "/prime/api/v1/product/promo-codes/${widget.id}",
                                ),
                                body: jsonEncode(body),
                                headers: <String, String>{
                                  "Authorization": "Bearer $token",
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                });
                            // print(response.body);
                            var data = jsonDecode(response.body);
                            print(data);

                            if (data['statusCode'] == '000') {
                              displaySnack(
                                  context, "Promo-code placed successfully.");
                              // PromoCodeDashboard.FetchthePromocodes(context);
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
                            color: AppColors.colorPrimaryDark,
                          )
                        : Text(
                            'Edit',
                          ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text("Cancel")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text("View"))
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
