import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:commercepal_admin_flutter/core/transactions/domain/models/withdrawal_methods.dart';
import 'package:commercepal_admin_flutter/core/transactions/presentation/bloc/transaction_cubit.dart';
import 'package:commercepal_admin_flutter/core/transactions/presentation/bloc/transaction_state.dart';
import 'package:commercepal_admin_flutter/core/transactions/presentation/widgets/select_withdrawal_method_widget.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_button.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_scaffold.dart';
import 'package:commercepal_admin_flutter/feature/merchant/dashboard/merchant_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../core/widgets/app_textfield.dart';

class WithdrawPage extends StatefulWidget {
  static const routeName = "/withdraw";

  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class Bankdata {
  final String instName;
  final String instId;
  Bankdata({required this.instName, required this.instId});
}

class _WithdrawPageState extends State<WithdrawPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String? _customerName;
  String? transRef;
  List<Bankdata> banks = [];
  String? _accountNumber;
  String? _phoneNumber;
  var loading = false;
  var loading1 = false;
  String? _amount;
  String? selectedBank;
  WithdrawalMethod? _withdrawalMethod;
  String? userName;
  FocusNode amountFocus = FocusNode();
  // void initstate() {
  //   super.initState();
  //   fetchBankData();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TransactionCubit>(),
      child: BlocConsumer<TransactionCubit, TransactionState>(
        listener: (ctx, state) {
          if (state is TransactionStateError) {
            ctx.displaySnack(state.error);
          }

          if (state is TransactionStateSahayValidated) {
            setState(() {
              _customerName = state.name;
            });

            // display withdrawal confirmation
            ctx.displayDialog(
                onNegativeClicked: () {
                  // make customer null to allow subsequent requests
                  setState(() {
                    _customerName = null;
                  });
                },
                title: 'Withdrawal confirmation',
                message:
                    "Withdraw $_amount to account\n\nName: $_customerName\nNo. ${_withdrawalMethod?.name?.toLowerCase() == 'sahay' ? _phoneNumber : ''}");
          }
        },
        builder: (ctx, state) {
          return AppScaffold(
            appBarTitle: 'Withdraw',
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SelectWithdrawalMethodWidget(
                      onMethodSelected: (WithdrawalMethod withdrawalMethod) {
                    setState(() {
                      _withdrawalMethod = withdrawalMethod;
                      // _withdrawalMethod!.name == "Bank" ??

                      print(_withdrawalMethod!.name!.toLowerCase());
                      if (_withdrawalMethod != null &&
                          _withdrawalMethod!.name?.toLowerCase() == 'bank') {
                        if (banks.isEmpty) {
                          setState(() {
                            loading = true;
                          });
                          fetchBankData();
                        }
                      }
                    });
                  }),
                  if (_withdrawalMethod != null &&
                      _withdrawalMethod!.name?.toLowerCase() ==
                          'bank') // Conditionally show dropdown
                    Column(
                      children: [
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Select The Bank",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: DropdownButtonFormField<String>(
                            value: selectedBank,
                            onChanged: (value) {
                              setState(() {
                                selectedBank = value;
                              });
                            },
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
                            decoration: InputDecoration(
                              suffix: loading
                                  ? const SizedBox(
                                      height: 12,
                                      width: 12,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                      ))
                                  : const SizedBox(
                                      // child: Icon(
                                      //     Icons.arrow_drop_down_outlined),
                                      ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: BorderSide.none,
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: _validateField,
                          ),
                        ),
                      ],
                    ),
                  if (_withdrawalMethod != null &&
                      _withdrawalMethod!.name?.toLowerCase() !=
                          'bank') // Conditionally show AppTextField
                    AppTextField(
                      title: 'Phone',
                      textInputType: TextInputType.phone,
                      valueChanged: (value) {
                        setState(() {
                          _phoneNumber = value;
                        });
                      },
                      formFieldValidator: (value) {
                        if (value?.isEmpty == true) {
                          return 'Enter phone number';
                        }
                        return null;
                      },
                    ),
                  if (_withdrawalMethod != null &&
                      _withdrawalMethod!.name?.toLowerCase() ==
                          'bank') // Conditionally show AppTextField
                    Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 8),
                              child: Text(
                                "Enter account Number",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onTapOutside: (event) {},
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[100],
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              // hintText: "Enter your password",
                              // labelText: 'Amount',
                            ),
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
                        ),
                      ],
                    ),
                  const Row(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                        child: Text(
                          "Amount",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      focusNode: amountFocus,
                      onTapOutside: (event) {
                        amountFocus.unfocus();
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        // hintText: "Enter your password",
                        // labelText: 'Amount',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _amount = value;
                        });
                      },
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'Enter amount';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (_withdrawalMethod != null &&
                      _withdrawalMethod!.name?.toLowerCase() != 'bank')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppButtonWidget(
                          isLoading: state is TransactionStateLoading,
                          onClick: () {
                            FocusScope.of(context).unfocus();

                            if (_withdrawalMethod == null) {
                              context.displaySnack('Select withdrawal method');
                              return;
                            }

                            if (_formKey.currentState?.validate() == true) {
                              // validate sahay customer name
                              if (_withdrawalMethod!.name?.toLowerCase() ==
                                      'sahay' &&
                                  _customerName == null) {
                                ctx
                                    .read<TransactionCubit>()
                                    .validateSahayNumber(_phoneNumber!);
                                return;
                              }
                            }
                          }),
                    ),
                  if (_withdrawalMethod != null &&
                      _withdrawalMethod!.name?.toLowerCase() == 'bank')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.colorAccent),
                            child: loading1
                                ? const Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text("Submit"),
                            // isLoading: state is TransactionStateLoading,
                            onPressed: () async {
                              FocusScope.of(context).unfocus();

                              if (_withdrawalMethod == null) {
                                context
                                    .displaySnack('Select withdrawal method');
                                return;
                              }

                              if (_formKey.currentState?.validate() == true) {
                                // validate sahay customer name
                                if (_withdrawalMethod!.name?.toLowerCase() ==
                                    'bank') {
                                  bool isSuccess = await verifyUser();
                                  setState(() {
                                    loading1 = false;
                                  });
                                  if (isSuccess == false) {
                                    // ignore: use_build_context_synchronously
                                    context.displaySnack(
                                        'Invalid Account Number or Bank');
                                  } else if (userName != null) {
                                    // ignore: use_build_context_synchronously
                                    ctx.displayDialog(
                                        onPClicked: () async {
                                          bool done = await withdrawAmount();
                                          if (done) {
                                            // ignore: use_build_context_synchronously
                                            ctx.displayDialog(
                                                title: "Sent to Withdraw",
                                                message:
                                                    'Your transacton will be approved by warehouse. \n transRef: $transRef');
                                            setState(() {
                                              selectedBank = null;
                                              _accountNumber = null;
                                              _amount = null;
                                            });
                                            // ignore: use_build_context_synchronously
                                            Navigator.pushNamed(
                                                context,
                                                MerchantDashboardPage
                                                    .routeName);
                                          } else {
                                            // ignore: use_build_ctx_synchronously, use_build_context_synchronously
                                            ctx.displayDialog(
                                                title: "Error",
                                                message:
                                                    'There is a pending request');

                                            // Navigator.pop(context);
                                          }
                                        },
                                        title: 'Withdrawal Confirmation',
                                        message:
                                            "Do you want to withdraw $_amount ETB to $userName.");
                                  }
                                }
                              }
                            }),
                      ),
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
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
        final response = await http.post(
            Uri.https("pay.commercepal.com", "/payment/v1/request"),
            body: jsonEncode(payload),
            headers: <String, String>{"Authorization": "Bearer $token"});
        // print(response.body);
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
        loading1 = true;
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
            Uri.https("pay.commercepal.com", "/payment/v1/request"),
            body: jsonEncode(payload),
            headers: <String, String>{"Authorization": "Bearer $token"});
        // print(response.body);
        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          setState(() {
            loading1 = false;
            userName = data['customerName'];
          });
          return true;
        } else {
          setState(() {
            loading1 = false;
          });
          return false;
        }
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        loading1 = false;
      });
      return false;
    }
    setState(() {
      loading1 = false;
    });
    return false;
  }

  Future<bool> withdrawAmount() async {
    try {
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
            Uri.https("pay.commercepal.com",
                "/prime/api/v1/merchant/transaction/request-withdrawal"),
            body: jsonEncode(payload),
            headers: <String, String>{"Authorization": "Bearer $token"});
        // print(response.body);
        var data = jsonDecode(response.body);
        print(data);
        transRef = data["transRef"];

        if (data['statusCode'] == '000') {
          return true;
        } else {
          transRef = data['statusMessage:'];
          return false;
        }
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
    return false;
  }
}
