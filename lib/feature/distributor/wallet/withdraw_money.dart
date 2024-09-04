import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WithdrawMoney extends StatefulWidget {
  const WithdrawMoney({super.key});

  @override
  State<WithdrawMoney> createState() => _WithdrawMoneyState();
}

class Bankdata {
  final String instName;
  final String instId;
  Bankdata({required this.instName, required this.instId});
}

class _WithdrawMoneyState extends State<WithdrawMoney> {
  var loading = false;
  List<Bankdata> banks = [];
  String? selectedMethod;
  String? selectedBank;
  String? _accountNumber;
  String? _amount;
  String? mobileNumber;
  String? userName;
  String? transRef;
  bool pop = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    fetchBankData();
  }

  @override
  Widget build(BuildContext context) {
    // var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Withdraw",
          style: TextStyle(fontSize: sWidth * 0.05),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Select Withdrawal Method"),
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        items: const [
                          DropdownMenuItem<String>(
                            value: "sahay",
                            child: Center(
                              child: Text(
                                'Sahay',
                              ),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: "bank",
                            child: Center(
                              child: Text(
                                'Bank',
                              ),
                            ),
                          )
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedMethod = value;
                          });
                        },
                        // value: hereData!.isNotEmpty ? hereData![2] : null,
                      ),
                      if (selectedMethod != null &&
                          selectedMethod.toString() == "bank")
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text("Select Bank"),
                        ),
                      if (selectedMethod != null &&
                          selectedMethod.toString() == "bank")
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: AppColors.greyColor,
                              focusedBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              enabledBorder: InputBorder.none),
                          items: banks.map((Bankdata bank) {
                            return DropdownMenuItem<String>(
                              value: bank.instId.toString(),
                              child: Text(
                                bank.instName,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedBank = value;
                            });
                          },
                          // value: hereData!.isNotEmpty ? hereData![2] : null,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Bank is required';
                            }
                            return null;
                          },
                        ),
                      if (selectedMethod != null &&
                          selectedMethod.toString() == "bank")
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text("Account Number"),
                        ),
                      if (selectedMethod != null &&
                          selectedMethod.toString() == "bank")
                        TextFormField(
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: AppColors.greyColor,
                              focusedBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              enabledBorder: InputBorder.none),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _accountNumber = value;
                            });
                          },
                          validator: (value) {
                            if (value?.isEmpty == true) {
                              return 'Account number is required';
                            }
                            return null;
                          },
                        ),
                      if (selectedMethod != null &&
                          selectedMethod.toString() == "sahay")
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text("Mobile Number"),
                        ),
                      if (selectedMethod != null &&
                          selectedMethod.toString() == "sahay")
                        TextFormField(
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: AppColors.greyColor,
                              focusedBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              enabledBorder: InputBorder.none),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            setState(() {
                              mobileNumber = value;
                            });
                          },
                          validator: (value) {
                            // Define your regular expressions
                            var regExp1 = RegExp(r'^0\d{9}$');
                            var regExp2 = RegExp(r'^\+251\d{9}$');
                            var regExp3 = RegExp(r'^\251\d{9}$');

                            // Check if the entered value matches either expression
                            if (!(regExp1.hasMatch(value!) ||
                                regExp3.hasMatch(value) ||
                                regExp2.hasMatch(value))) {
                              return 'Enter a valid mobile number';
                            }

                            // Validation passed
                            return null;
                          },
                        ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Amount"),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _amount = value;
                          });
                        },
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return 'Amount is required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                )),
            if (selectedMethod != null && selectedMethod.toString() == "bank")
              loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.colorPrimaryDark),
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            selectedMethod!.toLowerCase() == "bank") {
                          bool isSuccess = await verifyUser();
                          setState(() {
                            loading = false;
                          });
                          if (isSuccess == false) {
                            // ignore: use_build_context_synchronously
                            context
                                .displaySnack('Invalid Account Number or Bank');
                          } else if (userName != null) {
                            // ignore: use_build_context_synchronously
                            context.displayDialog(
                                onPClicked: () async {
                                  bool done = await withdrawAmount();
                                  if (done) {
                                    // ignore: use_build_context_synchronously
                                    context.displayDialog(
                                        title: "Sent to Withdraw",
                                        message:
                                            'Your transacton will be approved by warehouse. \n transRef: $transRef');
                                    setState(() {
                                      selectedBank = null;
                                      _accountNumber = null;
                                      _amount = null;
                                    });
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context);
                                  } else {
                                    // ignore: use_build_ctx_synchronously, use_build_context_synchronously
                                    context.displayDialog(
                                        title: "Error",
                                        message: 'There is a pending request');

                                    // Navigator.pop(context);
                                  }
                                },
                                title: 'Withdrawal Confirmation',
                                message:
                                    "Do you want to withdraw $_amount ETB to $userName.");
                          }
                        }
                      },
                      child: const Text(
                        "Withdraw to Bank",
                        style: TextStyle(color: AppColors.bgCreamWhite),
                      )),
            if (selectedMethod != null && selectedMethod.toString() == "sahay")
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.colorPrimaryDark),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool change = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Withdraw to Sahay'),
                            content: Text(
                                'Do you want to Withdraw $_amount ETB to $mobileNumber?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      false); // User does not confirm deletion
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(true); // User confirms deletion
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                      if (change) {
                        bool done = await withdrawtoSahay();
                        if (done) {
                          // ignore: use_build_context_synchronously
                          pop = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Done'),
                                content: const Text(
                                    'Your request is sent to Warehouse to be approved'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(true); // User confirms deletion
                                    },
                                    child: const Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: Text('There is a pending request.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(true); // User confirms deletion
                                    },
                                    child: const Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    }
                    await Future.delayed(const Duration(seconds: 3));
                    if (pop) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Withdraw to Sahay",
                    style: TextStyle(color: AppColors.bgCreamWhite),
                  ))
          ],
        ),
      )),
    );
  }

  Future<void> fetchBankData() async {
    try {
      setState(() {
        loading = true;
      });
      print("hereeee");
      Map<String, dynamic> payload = {
        "UserType": "M",
        "ServiceCode": "ES-BANK-LOOKUP",
      };
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        // print(token);
        final response = await http.post(
            Uri.https("api.commercepal.com:2095", "/payment/v1/request"),
            body: jsonEncode(payload),
            headers: <String, String>{"Authorization": "Bearer $token"});
        print(response.body);
        var data = jsonDecode(response.body);
        banks.clear();
        for (var b in data['data']) {
          banks.add(Bankdata(instName: b['InstName'], instId: b['InstId']));
        }
        print(banks.length);
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
    }
    setState(() {
      loading = false;
    });
  }

  Future<bool> verifyUser() async {
    try {
      setState(() {
        loading = true;
      });
      print("hereeeeweare");
      Map<String, dynamic> payload = {
        "UserType": "M",
        "ServiceCode": "ES-ACCOUNT-LOOKUP",
        "InstId": selectedBank.toString(),
        "Account": _accountNumber.toString(),
      };
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.post(
            Uri.https("api.commercepal.com:2095", "/payment/v1/request"),
            body: jsonEncode(payload),
            headers: <String, String>{"Authorization": "Bearer $token"});
        // print(response.body);
        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          setState(() {
            loading = false;
            userName = data['customerName'];
          });
          return true;
        } else {
          setState(() {
            loading = false;
          });
          return false;
        }
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
      return false;
    }
    setState(() {
      loading = false;
    });
    return false;
  }

  Future<bool> withdrawAmount() async {
    try {
      setState(() {
        loading = true;
      });
      print("hereeeewego");
      Map<String, dynamic> payload = {
        "WithdrawalMethod": "SAHAY-SESFT",
        "WithdrawalType": "ETHIO-SWITCH",
        "Amount": _amount.toString(),
        "InstId": selectedBank.toString(),
        "Account": _accountNumber.toString()
      };
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.post(
            Uri.https("api.commercepal.com:2095",
                "/prime/api/v1/distributor/transaction/request-withdrawal"),
            body: jsonEncode(payload),
            headers: <String, String>{"Authorization": "Bearer $token"});
        // print(response.body);
        var data = jsonDecode(response.body);
        print(data);
        setState(() {
          transRef = data["transRef"];
        });

        if (data['statusCode'] == '000') {
          setState(() {
            loading = false;
          });
          return true;
        } else {
          setState(() {
            loading = false;
            transRef = data['statusMessage:'];
          });
          setState(() {
            loading = false;
          });
          return false;
        }
      }
      setState(() {
        loading = true;
      });
    } catch (e) {
      setState(() {
        loading = true;
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

  Future<bool> withdrawtoSahay() async {
    try {
      setState(() {
        loading = true;
      });
      print("hereeeewego");
      Map<String, dynamic> payload = {
        "WithdrawalMethod": "SAHAY-SWFT",
        "WithdrawalType": "WALLLET",
        "Account": mobileNumber.toString(),
        "Amount": int.parse(_amount!)
      };
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.post(
            Uri.https("api.commercepal.com:2095",
                "/prime/api/v1/merchant/transaction/request-withdrawal"),
            body: jsonEncode(payload),
            headers: <String, String>{"Authorization": "Bearer $token"});
        // print(response.body);
        var data = jsonDecode(response.body);
        print(data);
        setState(() {
          transRef = data["transRef"];
        });

        if (data['statusCode'] == '000') {
          setState(() {
            loading = false;
          });
          return true;
        } else {
          setState(() {
            loading = false;
            transRef = data['statusMessage:'];
          });
          setState(() {
            loading = false;
          });
          return false;
        }
      }
      setState(() {
        loading = false;
      });
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
