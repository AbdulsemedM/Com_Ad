import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/routes.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/agent/topup_float/redeem_float.dart';
import 'package:commercepal_admin_flutter/feature/agent/topup_float/request_float.dart';
import 'package:commercepal_admin_flutter/feature/login/presentation/login_page.dart';
import 'package:flutter/material.dart';

class TopupFloatPage extends StatefulWidget {
  final String userName;
  const TopupFloatPage({Key? key, required this.userName}) : super(key: key);

  @override
  State<TopupFloatPage> createState() => _TopupFloatPageState();
}

class _TopupFloatPageState extends State<TopupFloatPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final List<Tab> _tabs = const [
    Tab(text: "Request Float"),
    Tab(text: "Redeem Float"),
  ];
  final List<Widget> _pages = const [
    RequestFloat(),
    RedeemFloat(),
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
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
        child: Column(
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
        ),
      ),
    );
  }
}
