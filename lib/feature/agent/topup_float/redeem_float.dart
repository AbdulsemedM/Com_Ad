import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RedeemFloat extends StatefulWidget {
  const RedeemFloat({super.key});

  @override
  State<RedeemFloat> createState() => _RedeemFloatState();
}

class _RedeemFloatState extends State<RedeemFloat> {
  final TextEditingController transRef = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool loading = false;
  String message = '';
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
                        child: Text("Trans. Reference"),
                      ),
                    ],
                  ),
                  TextFormField(
                    enabled: false,
                    controller: transRef,
                    decoration: const InputDecoration(
                        hintText: 'Enter transaction reference',
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
                        return 'Transaction reference is required';
                      }
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
                        context.displaySnack("will be available soon.");
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.greyColor),
                      child: const Text(
                        "Redeem Float",
                        style: TextStyle(color: AppColors.colorAccent),
                      )))
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
        "amount": double.parse(transRef.text),
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
