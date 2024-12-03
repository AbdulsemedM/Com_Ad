import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/distributor/wallet/wallet_commission.dart';
import 'package:commercepal_admin_flutter/feature/distributor/wallet/wallet_transactions.dart';
import 'package:commercepal_admin_flutter/feature/distributor/wallet/withdraw_money.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyWallet extends StatefulWidget {
  const MyWallet({super.key});

  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet>
    with SingleTickerProviderStateMixin {
  var loading = false;
  String? balance;
  TabController? _tabController;
  final List<Tab> _tabs = const [
    Tab(text: "Payment"),
    Tab(text: "Commission"),
  ];
  final List<Widget> _pages = const [
    // SizedBox(height: 50, child: Center(child: Text("data1"))),
    // SizedBox(height: 50, child: Center(child: Text("dat2")))
    WalletTransactions(),
    WalletCommission(),
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    fetchFloatingBalance();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Stack(children: [
          Column(
            children: [
              Container(
                width: sWidth * 1,
                decoration: const BoxDecoration(color: AppColors.greyColor),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Floating Balance",
                          style: TextStyle(fontSize: sWidth * 0.04)),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "Balance",
                  style: TextStyle(fontSize: sWidth * 0.05),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text("${balance ?? 0} ETB",
                    style: TextStyle(fontSize: sWidth * 0.06)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  width: sWidth * 1,
                  decoration: const BoxDecoration(color: AppColors.greyColor),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Transactions",
                            style: TextStyle(fontSize: sWidth * 0.04)),
                      )
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        TabBar(
                            indicatorSize: TabBarIndicatorSize.label,
                            isScrollable: true,
                            labelColor: AppColors.primaryTextColor,
                            controller: _tabController,
                            tabs: _tabs),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: sHeight * 0.7,
                    child: TabBarView(
                      controller: _tabController,
                      children: _pages,
                    ),
                  ),
                ],
              )
            ],
          ),
          Positioned(
            bottom: sHeight * 0.01,
            right: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textColor),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WithdrawMoney()));
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wallet_rounded,
                      color: AppColors.colorPrimary,
                    ),
                    Text(
                      'Withdraw',
                      style: TextStyle(
                        color: AppColors.colorPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ])),
      ),
    );
  }

  Future<void> fetchFloatingBalance({int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.get(
          Uri.https(
            "pay.commercepal.com",
            "/prime/api/v1/distributor/transaction/account-balance",
          ),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        // print(data);

        if (data['statusCode'] == '000') {
          setState(() {
            balance = data['balance'].toString();
            loading = false;
          });
          // Handle the case when statusCode is '000'
        } else {
          // Retry logic
          if (retryCount < 5) {
            // Retry after num + 1 seconds
            await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await fetchFloatingBalance(retryCount: retryCount + 1);
          } else {
            setState(() {
              loading = true;
            });
            // Retry limit reached, handle accordingly
          }
        }
      }
    } catch (e) {
      setState(() {
        loading = true;
      });
      print(e.toString());

      // Handle other exceptions
    }
  }
}
