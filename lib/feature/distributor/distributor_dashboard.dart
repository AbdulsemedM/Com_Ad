import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/routes.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/distributor/registration/agent_registration/register_agent.dart';
import 'package:commercepal_admin_flutter/feature/distributor/registration/business_registration/register_business.dart';
import 'package:commercepal_admin_flutter/feature/distributor/registration/merchant_registration/register_merchant.dart';
import 'package:commercepal_admin_flutter/feature/distributor/tab_bar_widgets/Overview.dart';
import 'package:commercepal_admin_flutter/feature/distributor/tab_bar_widgets/agent.dart';
import 'package:commercepal_admin_flutter/feature/distributor/tab_bar_widgets/bussiness.dart';
import 'package:commercepal_admin_flutter/feature/distributor/tab_bar_widgets/merchant.dart';
import 'package:commercepal_admin_flutter/feature/distributor/wallet/my_wallet.dart';
import 'package:commercepal_admin_flutter/feature/login/presentation/login_page.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DistributorDashboard extends StatefulWidget {
  const DistributorDashboard({super.key});

  @override
  State<DistributorDashboard> createState() => _DistributorDashboardState();
}

class _DistributorDashboardState extends State<DistributorDashboard>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String register = "Agent";
  String? registered;
  final List<Tab> _tabs = const [
    Tab(text: "Overview"),
    Tab(text: "Agents"),
    Tab(text: "Merchant"),
    Tab(text: "Business"),
  ];
  final List<Widget> _pages = const [
    OverviewTab(),
    AgentTab(),
    MerchantTab(),
    BussinessTab(),
  ];

  String? name;
  var loading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    fetchUser();
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(sHeight * 0.23),
        child: AppBar(
          primary: false,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.colorAccent,
          elevation: 1, // Set elevation to 0 to remove shadow
          // shape: const RoundedRectangleBorder(
          //   borderRadius: BorderRadius.only(
          //     bottomLeft: Radius.circular(20),
          //     bottomRight: Radius.circular(20),
          //   ),
          // ),
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
                            "Dashboard",
                            style: TextStyle(
                                fontSize: sWidth * 0.06,
                                color: AppColors.bgCreamWhite,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            bool change = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Change role'),
                                  content: const Text(
                                      'Do you want to change this role?'),
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
                                        Navigator.of(context).pop(
                                            true); // User confirms deletion
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (change) {
                              Navigator.pop(context);
                            }
                          },
                          child: Icon(
                            Icons.change_circle_outlined,
                            color: AppColors.textColor,
                            size: sWidth * 0.08,
                          ),
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
                            child: Center(child: loading ? Container() : Text(
                                // name!.isNotEmpty
                                //   ? '${name![0]}${name!.split(' ').last[0]}'
                                //   :
                                '')),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: loading
                                    ? Container()
                                    : Text(
                                        '',
                                        // '${name!.isNotEmpty ? name :
                                        // ""}
                                        // ',
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
                                      "Distributor",
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
      body: Stack(children: [
        SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  child: Column(
                    children: [
                      TabBar(
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
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: sHeight * 0.03,
          right: 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textColor),
              onPressed: () {
                showModalBottomSheet(
                  showDragHandle: true,
                  // isDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: sHeight * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.bgCreamWhite,
                      ),
                      // Add your content inside the Container
                      child: Column(
                        children: [
                          Text(
                            "What do you want to register?",
                            style: TextStyle(fontSize: sWidth * 0.04),
                          ),
                          CustomRadioButton(
                            padding: 2,
                            unSelectedBorderColor: AppColors.bgCreamWhite,
                            height: sHeight * 0.06,
                            elevation: 0,
                            horizontal: true,
                            absoluteZeroSpacing: true,
                            unSelectedColor: Theme.of(context).canvasColor,
                            defaultSelected: "Agent",
                            buttonLables: const [
                              'Agent',
                              'Merchant',
                              'Business',
                            ],
                            buttonValues: const [
                              "Agent",
                              "Merchant",
                              "Business",
                            ],
                            buttonTextStyle: const ButtonTextStyle(
                                selectedColor: Colors.white,
                                unSelectedColor: Colors.black,
                                textStyle: TextStyle(fontSize: 16)),
                            radioButtonValue: (value) {
                              setState(() {
                                register = value;
                              });
                              // print(register);
                            },
                            selectedColor: AppColors.colorAccent,
                          ),
                          SizedBox(
                            width: sWidth * 0.7,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.colorAccent),
                              onPressed: () async {
                                setState(() {
                                  registered = register;
                                  register = "Agent";
                                });
                                switch (registered) {
                                  case "Agent":
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setStringList("step1", []);
                                    prefs.setStringList("step2", []);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterAgent()));
                                    break;
                                  case "Merchant":
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setStringList("step1", []);
                                    prefs.setStringList("step2", []);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterMerchant()));
                                    break;
                                  case "Business":
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setStringList("step1", []);
                                    prefs.setStringList("step2", []);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterBusiness()));
                                    break;
                                }
                                print(registered);
                              },
                              child: const Text("Proceed to Registration form",
                                  style: TextStyle(color: AppColors.bg1)),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.note_add_outlined,
                    color: AppColors.colorPrimary,
                  ),
                  Text(
                    'New Registration',
                    style: TextStyle(color: AppColors.colorPrimary),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: sHeight * 0.03,
          left: 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textColor),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyWallet()));
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
                    'Wallet',
                    style: TextStyle(color: AppColors.colorPrimary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> fetchUser({int retryCount = 0}) async {
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
            "api.commercepal.com:2096",
            "prime/api/v1/get-details",
            {"userType": "BUSINESS"},
          ),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        print(data['statusCode']);

        if (data['statusCode'] == '000') {
          setState(() {
            name = data['Details']['firstName'] +
                " " +
                data['Details']['lastName'];
            // image = data[]
            loading = false;
            print(name);
          });
          // Handle the case when statusCode is '000'
        } else {
          // Retry logic
          if (retryCount < 5) {
            // Retry after num + 1 seconds
            await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await fetchUser(retryCount: retryCount + 1);
          } else {
            // Retry limit reached, handle accordingly
            setState(() {
              loading = false;
            });
          }
        }
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
      // Handle other exceptions
    }
  }
}
