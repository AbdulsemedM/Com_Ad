import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/feature/merchant/flash_sale/flash_sale_dashboard.dart';
import 'package:commercepal_admin_flutter/feature/merchant/promo_code/promo_code_dashboard.dart';
import 'package:flutter/material.dart';

class PromotionTab extends StatefulWidget {
  const PromotionTab({super.key});

  @override
  State<PromotionTab> createState() => _PromotionTabState();
}

class _PromotionTabState extends State<PromotionTab>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _selectedIndex = 0; // Variable to store the selected index
  final List<Tab> _tabs = const [
    Tab(text: "Promo-Code"),
    Tab(text: "Flash-Sale"),
    // Tab(text: "Social funds"),
    // Tab(text: "Penalty payments"),
    // Tab(text: "Penalties"),
  ];
  final List<Widget> _pages = const [
    PromoCodeDashboard(),
    FlashSaleDashboard(),
    // SocialFundsPayment(),
    // PenaltyPayment(),
    // PaidPenalties()
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController!.addListener(
        _handleTabSelection); // Add listener to handle tab selection
  }

  void _handleTabSelection() {
    setState(() {
      _selectedIndex = _tabController!.index; // Update selected index variable
    });
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
          title: const Text("Promotional Campaigns",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17))),
      body: SingleChildScrollView(
          child: SafeArea(
              child: Column(
        children: [
          Center(
            child: TabBar(
              isScrollable: true,
              indicatorColor: AppColors.colorPrimaryDark,
              labelColor: AppColors.colorPrimaryDark,
              controller: _tabController,
              tabs: _tabs,
            ),
          ),
          SizedBox(
            height: sHeight * 0.85,
            child: TabBarView(
              controller: _tabController,
              children: _pages,
            ),
          ),
        ],
      ))),
    );
  }
}
