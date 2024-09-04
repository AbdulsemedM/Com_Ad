import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RequestFloat extends StatefulWidget {
  const RequestFloat({super.key});

  @override
  State<RequestFloat> createState() => _RequestFloatState();
}

class _RequestFloatState extends State<RequestFloat> {
  final TextEditingController amount = TextEditingController();
  final TextEditingController comment = TextEditingController();

  // String? amount;
  // String? comment;
  bool loading = false;
  String message = '';
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            height: sHeight * 0.05,
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Amount"),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: amount,
                    decoration: const InputDecoration(
                        hintText: 'Enter Amount',
                        filled: true,
                        fillColor: AppColors.greyColor,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none),
                    // : 'Full Name',
                    keyboardType: TextInputType.number,
                    // onChanged: (value) {
                    //   setState(() {
                    //     amount = value;
                    //   });
                    // },
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Amount is required';
                      }
                      return null;
                    },
                  ),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Comment"),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: comment,
                    decoration: const InputDecoration(
                        hintText: "Enter Comment",
                        filled: true,
                        fillColor: AppColors.greyColor,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none),
                    keyboardType: TextInputType.text,
                    // onChanged: (value) {
                    //   setState(() {
                    //     comment = value;
                    //   });
                    // },
                    validator: (value) {
                      return null;
                    },
                  ),
                ],
              )),
          SizedBox(
            height: sHeight * 0.03,
          ),
          loading
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: sWidth,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool done = await verifyForm();
                          if (done) {
                            // ignore: use_build_context_synchronously
                            context.displaySnack(message);
                            setState(() {
                              amount.clear();
                              comment.clear();
                            });
                          } else {
                            // ignore: use_build_context_synchronously
                            context.displaySnack(message);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.colorAccent),
                      child: const Text("Request Float")))
        ],
      ),
    );
  }

  Future<bool> verifyForm() async {
    try {
      setState(() {
        loading = true;
      });
      Map<String, dynamic> payload = {
        "amount": double.parse(amount.text),
        "comment": comment.text,
      };
      print(payload);

      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.post(
            Uri.https("api.commercepal.com:2096",
                "/prime/api/v1/agent/transaction/request-float"),
            body: jsonEncode(payload),
            headers: <String, String>{"Authorization": "Bearer $token"});
        // print(response.body);
        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          setState(() {
            message = "Float request sent successfully";
            loading = false;
          });
          return true;
        } else {
          message = data['statusMessage:'];
          setState(() {
            loading = false;
          });
          return false;
        }
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
      return false;
    } finally {
      setState(() {
        loading = false;
      });
    }
    return false;
  }
}
