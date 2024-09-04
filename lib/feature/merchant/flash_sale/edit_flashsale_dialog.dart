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

class EditFlashSaleDialog extends StatefulWidget {
  final String id;
  final String flashSalePrice;
  final String flashSaleStartDate;
  final String flashSaleEndDate;
  final String flashSaleInventoryQuantity;
  final String isQuantityRestrictionPerCustomer;
  final String flashSaleMinQuantityPerCustomer;
  final String flashSaleMaxQuantityPerCustomer;
  final String productName;
  const EditFlashSaleDialog(
      {super.key,
      required this.flashSalePrice,
      required this.flashSaleInventoryQuantity,
      required this.flashSaleEndDate,
      required this.isQuantityRestrictionPerCustomer,
      required this.id,
      required this.flashSaleMinQuantityPerCustomer,
      required this.flashSaleMaxQuantityPerCustomer,
      required this.productName,
      required this.flashSaleStartDate});
  @override
  _EditFlashSaleDialogState createState() => _EditFlashSaleDialogState();
}

class _EditFlashSaleDialogState extends State<EditFlashSaleDialog> {
  var loading = false;
  TextEditingController flashSalePriceController = TextEditingController();
  TextEditingController flashSaleInventoryQuantityController =
      TextEditingController();
  TextEditingController flashSaleStartController = TextEditingController();
  TextEditingController flashSaleEndController = TextEditingController();
  TextEditingController flashSaleMinQuantityPerCustomercontroller =
      TextEditingController();
  TextEditingController flashSaleMaxQuantityPerCustomerController =
      TextEditingController();
  bool? isQuantityRestrictedPerCustomer;
  var loading1 = false;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    flashSaleStartController.text = DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(widget.flashSaleStartDate.toString()));
    flashSaleEndController.text = DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(widget.flashSaleEndDate.toString()));
    flashSaleInventoryQuantityController.text =
        widget.flashSaleInventoryQuantity.toString();
    flashSalePriceController.text = widget.flashSalePrice.toString();
    flashSaleMaxQuantityPerCustomerController.text =
        widget.flashSaleMaxQuantityPerCustomer;
    flashSaleMinQuantityPerCustomercontroller.text =
        widget.flashSaleMinQuantityPerCustomer;
    if (widget.isQuantityRestrictionPerCustomer == "true") {
      isQuantityRestrictedPerCustomer = true;
    } else if (widget.isQuantityRestrictionPerCustomer == "false") {
      isQuantityRestrictedPerCustomer = false;
    }
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
        flashSaleStartController.text = DateFormat('yyyy-MM-dd')
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
        flashSaleEndController.text =
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
        'Edit ${widget.productName} Flash Sale',
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
                          keyboardType: TextInputType.number,
                          validator: _validateField,
                          controller: flashSalePriceController,
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
                            labelText: "Flash Sale Price (ETB)",
                            // hintText: "Ex. Test promo code",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: _validateField,
                          controller: flashSaleInventoryQuantityController,
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
                            labelText: "Inventory Quantity",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: _validateField,
                          controller: flashSaleMinQuantityPerCustomercontroller,
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
                            labelText: "Min Quantity per Customer",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: _validateField,
                          controller: flashSaleMaxQuantityPerCustomerController,
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
                            labelText: "Max Quntity per Quantity",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: DropdownButtonFormField<String>(
                          value:
                              widget.isQuantityRestrictionPerCustomer == 'true'
                                  ? 'true'
                                  : 'false',
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(
                                12.0, 10.0, 12.0, 10.0),
                            labelText: "Quantity Restricted per Customer",
                            hintText: "yes / no",
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
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: AppColors.colorPrimaryDark),
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          items: const [
                            DropdownMenuItem<String>(
                              value: 'true',
                              child: Center(
                                child: Text(
                                  'Yes',
                                ),
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "false",
                              child: Center(
                                child: Text(
                                  'No',
                                ),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              if (value == "true") {
                                isQuantityRestrictedPerCustomer = true;
                              } else if (value == "false") {
                                isQuantityRestrictedPerCustomer = false;
                              }
                            });
                          },
                          hint: Text(
                            "yes / no",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          validator: _validateField,
                          controller: flashSaleStartController,
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
                          controller: flashSaleEndController,
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
                      // print(widget.subProductId);
                      if (!_myForm.currentState!.validate()) {
                        // print(widget.subProductId);
                      } else {
                        setState(() {
                          loading = true;
                        });
                        // print(widget.subProductId);
                        final body = {
                          "flashSalePrice":
                              double.parse(flashSalePriceController.text),
                          "flashSaleStartDate":
                              "${flashSaleStartController.text} 15",
                          "flashSaleEndDate":
                              "${flashSaleEndController.text} 15",
                          "flashSaleInventoryQuantity": int.parse(
                              flashSaleInventoryQuantityController.text),
                          "isQuantityRestrictionPerCustomer":
                              isQuantityRestrictedPerCustomer,
                          "flashSaleMinQuantityPerCustomer": int.parse(
                              flashSaleMinQuantityPerCustomercontroller.text),
                          "flashSaleMaxQuantityPerCustomer": int.parse(
                              flashSaleMaxQuantityPerCustomerController.text)
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
                                  "/prime/api/v1/product/flash-sales/${widget.id}",
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
                                  context, "Flash-Sale edited successfully.");
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
