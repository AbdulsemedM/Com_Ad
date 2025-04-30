import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/routes.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:commercepal_admin_flutter/feature/login/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class ReceiveCashPage extends StatefulWidget {
  final String userName;
  const ReceiveCashPage({Key? key, required this.userName}) : super(key: key);
  @override
  State<ReceiveCashPage> createState() => _ReceiveCashPageState();
}

class _ReceiveCashPageState extends State<ReceiveCashPage> {
  TextEditingController valCode = TextEditingController();
  TextEditingController ordRef = TextEditingController();
  TextEditingController traRef = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  bool scanDone = true;
  final GlobalKey<FormState> _formKey = GlobalKey();
  String message = '';
  var loading = false;
  bool manual = true;
  bool fetched = false;
  double? price;
  double? dPrice;
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
                        SizedBox(
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
        child: !scanDone
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      "Scan Customer Qrcode",
                      style: TextStyle(fontSize: sWidth * 0.05),
                    ),
                  )),
                  SizedBox(
                    height: sHeight * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: sHeight * 0.4,
                            child: QRView(
                              key: qrKey,
                              onQRViewCreated: _onQRViewCreated,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: sWidth * 0.8,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            scanDone = true;
                            manual = true;
                          });
                        },
                        child: const Text("Manual Entry")),
                  )
                ],
              )
            : (scanDone || manual) && !fetched
                ? Column(
                    children: [
                      Form(
                          child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Order Details",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: sWidth * 0.05),
                              ),
                            ),
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    const Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text("Validation code"),
                                        ),
                                      ],
                                    ),
                                    TextFormField(
                                      enabled: manual,
                                      controller: valCode,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter validation code',
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
                                          return 'Validation code is required';
                                        }
                                        return null;
                                      },
                                    ),
                                    const Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text("Phone Number"),
                                        ),
                                      ],
                                    ),
                                    TextFormField(
                                      enabled: manual,
                                      controller: ordRef,
                                      decoration: const InputDecoration(
                                          hintText: "0987654321",
                                          filled: true,
                                          fillColor: AppColors.greyColor,
                                          focusedBorder: InputBorder.none,
                                          focusedErrorBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none),
                                      keyboardType: TextInputType.number,
                                      // onChanged: (value) {
                                      //   setState(() {
                                      //     comment = value;
                                      //   });
                                      // },
                                      validator: (value) {
                                        if (value?.isEmpty == true) {
                                          return 'Phone number is required';
                                        }
                                        return null;
                                      },
                                    ),
                                    // const Row(
                                    //   children: [
                                    //     Padding(
                                    //       padding: EdgeInsets.symmetric(
                                    //           vertical: 8.0),
                                    //       child: Text("Trans. Ref"),
                                    //     ),
                                    //   ],
                                    // ),
                                    // TextFormField(
                                    //   enabled: manual,
                                    //   controller: traRef,
                                    //   decoration: const InputDecoration(
                                    //       hintText:
                                    //           "Enter transaction reference",
                                    //       filled: true,
                                    //       fillColor: AppColors.greyColor,
                                    //       focusedBorder: InputBorder.none,
                                    //       focusedErrorBorder: InputBorder.none,
                                    //       enabledBorder: InputBorder.none),
                                    //   keyboardType: TextInputType.text,
                                    //   // onChanged: (value) {
                                    //   //   setState(() {
                                    //   //     comment = value;
                                    //   //   });
                                    //   // },
                                    //   validator: (value) {
                                    //     if (value?.isEmpty == true) {
                                    //       return 'Trans Ref is required';
                                    //     }
                                    //     return null;
                                    //   },
                                    // ),
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
                                          if (_formKey.currentState!
                                              .validate()) {
                                            bool done = await verifyForm();
                                            if (done) {
                                              // ignore: use_build_context_synchronously
                                              context.displaySnack(message);
                                              // setState(() {
                                              //   // valCode.clear();
                                              //   // ordRef.clear();
                                              //   // traRef.clear();
                                              // });
                                            } else {
                                              // ignore: use_build_context_synchronously
                                              context.displaySnack(message);
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.colorAccent),
                                        child: const Text(
                                          "Confirm Amount",
                                          style: TextStyle(color: Colors.white),
                                        )))
                          ],
                        ),
                      ))
                    ],
                  )
                : fetched
                    ? Column(
                        children: [
                          Center(
                              child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "Total Payment summary",
                              style: TextStyle(
                                  color: Colors.black, fontSize: sWidth * 0.05),
                            ),
                          )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Item Price: ${price.toString()}",
                              style: TextStyle(fontSize: sWidth * 0.04),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Delivery Price: ${dPrice.toString()}",
                              style: TextStyle(fontSize: sWidth * 0.04),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Total Price: ${(dPrice! + price!).toString()}",
                              style: TextStyle(fontSize: sWidth * 0.05),
                            ),
                          ),
                          SizedBox(
                            height: sHeight * 0.1,
                          ),
                          loading
                              ? CircularProgressIndicator()
                              : SizedBox(
                                  width: sWidth * 0.9,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        bool confirm = await confirmAmount();
                                        if (confirm) {
                                          context.displaySnack(message);
                                          Navigator.popUntil(
                                              context,
                                              ModalRoute.withName(
                                                  '/agent_dashboard'));
                                        } else {
                                          context.displaySnack(message);
                                        }
                                      },
                                      child: const Text(
                                        "Confirm Amount Receipt",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                )
                        ],
                      )
                    : Container(),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scanDone = true;
        String scannedQRCode = scanData.code!;
        String decodedString = utf8.decode(base64.decode(scannedQRCode));
        Map<String, dynamic> jsonMap = json.decode(decodedString);
        valCode.text = jsonMap['ValidationCode'];
        ordRef.text = jsonMap['OrderRef'];
        traRef.text = jsonMap['TransRef'];
        print(decodedString);
        controller.pauseCamera();
      });
    });
  }

  Future<bool> verifyForm() async {
    try {
      setState(() {
        loading = true;
      });
      var pNumber = ordRef.text;
      pNumber = pNumber.replaceAll(RegExp(r'\s+'), '');
      if (pNumber.startsWith('0')) {
        pNumber = '251${pNumber.substring(1)}';
        print(pNumber);
      }
      Map<String, dynamic> payload = {
        "PhoneNumber": pNumber,
        "ValidCode": valCode.text
      };
      print(payload);

      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.post(
            Uri.https("pay.commercepal.com",
                "/prime/api/v1/agent/order/order-detail"),
            body: jsonEncode(payload),
            headers: <String, String>{"Authorization": "Bearer $token"});
        // print(response.body);
        var data = jsonDecode(response.body);
        print(data);

        // print((data['data']['TotalPrice']).toString());
        if (data['statusCode'] == '000') {
          setState(() {
            price = double.parse(data['data']['TotalPrice'].toString());
            dPrice = double.parse(data['data']['DeliveryPrice'].toString());
            message = data['statusMessage'];
            loading = false;
            fetched = true;
          });
          return true;
        } else {
          message = data['statusMessage'];
          setState(() {
            loading = false;
          });
          return false;
        }
      }
    } catch (e) {
      setState(() {
        message = "Something went wrong, please try again.";
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

  Future<bool> confirmAmount() async {
    try {
      setState(() {
        loading = true;
      });
      var pNumber = ordRef.text;
      pNumber = pNumber.replaceAll(RegExp(r'\s+'), '');
      if (pNumber.startsWith('0')) {
        pNumber = '251${pNumber.substring(1)}';
        print(pNumber);
      }
      Map<String, dynamic> payload = {
        "ServiceCode": "AGENT-CASH-FULFILLMENT",
        "AgentId": 2,
        "UserType": "A",
        "ValidCode": valCode.text,
        "PhoneNumber": pNumber,
        // "OrderRef": ordRef.text.toUpperCase(),
        // "TransRef": traRef.text.toUpperCase(),
      };
      print(payload);

      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.post(
            Uri.https("pay.commercepal.com", "/payment/v1/request"),
            body: jsonEncode(payload),
            headers: <String, String>{"Authorization": "Bearer $token"});
        // print(response.body);
        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          setState(() {
            message = data['statusMessage'];
            loading = false;
          });
          return true;
        } else {
          message = data['statusDescription'];
          setState(() {
            loading = false;
          });
          return false;
        }
      }
    } catch (e) {
      setState(() {
        message = "Something went wrong, please try again.";
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
