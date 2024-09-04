import 'package:commercepal_admin_flutter/core/session/presentation/session_cubit.dart';
import 'package:commercepal_admin_flutter/core/session/presentation/session_state.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_button.dart';
import 'package:commercepal_admin_flutter/feature/merchant/dashboard_orders/dashboard_orders.dart';
import 'package:commercepal_admin_flutter/feature/merchant/dashboard_products/dashboard_products.dart';
import 'package:commercepal_admin_flutter/feature/merchant/dashboard_transactions/dashboard_transactions.dart';
import 'package:commercepal_admin_flutter/feature/merchant/new_add_product/add_product_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di/injector.dart';
import '../../../app/utils/app_colors.dart';
import '../withdraw/withdraw_page.dart';

class MerchantDashboardPage extends StatefulWidget {
  static const routeName = '/merchant_dashboard';

  const MerchantDashboardPage({Key? key}) : super(key: key);

  @override
  State<MerchantDashboardPage> createState() => _MerchantDashboardPageState();
}

class _MerchantDashboardPageState extends State<MerchantDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCreamWhite,
      appBar: _dashboardAppBar(context),
      body: SafeArea(
        child: _widgetOptions[_selectedIndex],
      ),
      floatingActionButton: _selectedIndex == 1
          ? const SizedBox()
          : SizedBox(
              width: 140,
              child: AppButtonWidget(
                text: _selectedIndex == 0 ? 'Add Product' : 'Withdraw',
                onClick: () {
                  if (_selectedIndex == 0) {
                    Navigator.pushNamed(context, AddProductOne.routeName);
                  } else {
                    Navigator.pushNamed(context, WithdrawPage.routeName);
                  }
                },
              ),
            ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardProducts(),
    DashboardOrders(),
    DashboardTransactions()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  NavigationBar _buildBottomNavBar() {
    return NavigationBar(
      backgroundColor: Colors.white,
      destinations: <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined,
              color: _selectedIndex == 0
                  ? AppColors.colorPrimary
                  : Colors.black87),
          label: 'Products',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_bag_outlined,
              color: _selectedIndex == 1
                  ? AppColors.colorPrimary
                  : Colors.black87),
          label: 'Orders',
        ),
        NavigationDestination(
          icon: Icon(Icons.credit_card_outlined,
              color: _selectedIndex == 2
                  ? AppColors.colorPrimary
                  : Colors.black87),
          label: 'Transactions',
        ),
      ],
      indicatorColor: AppColors.colorPrimary.withOpacity(0.1),
      selectedIndex: _selectedIndex,
      //   selectedItemColor: ColorPalettes.colorPrimaryDark,
      onDestinationSelected: _onItemTapped,
    );
  }

  AppBar _dashboardAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: BlocProvider(
          create: (context) => getIt<SessionCubit>()..fetchMerchantDetails(),
          child: BlocBuilder<SessionCubit, SessionState>(
            builder: (context, state) {
              return state.maybeWhen(
                  orElse: () => const CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                  loading: () => const CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                  merchant: (merchant) => Text(
                        'Hello ${merchant.firstName} ${merchant.lastName}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.black87, fontSize: 16),
                      ));
            },
          ),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () async {
                  bool change = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Change role'),
                        content: const Text('Do you want to change this role?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(false); // User does not confirm deletion
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
                    Navigator.pop(context);
                  }
                },
                child: const Icon(
                  Icons.change_circle_outlined,
                  size: 30,
                  color: AppColors.primaryTextColor,
                ),
              ))
        ],
        leading: Container(
            height: 25,
            width: 25,
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: AppColors.colorPrimary.withAlpha(30),
                shape: BoxShape.circle),
            //TODO: find a better way to get the user name once - its a repetition on bloc above
            child: BlocProvider(
              create: (context) =>
                  getIt<SessionCubit>()..fetchMerchantDetails(),
              child: BlocBuilder<SessionCubit, SessionState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => const CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                    loading: () => const CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                    merchant: (user) => Text(
                      '${user.firstName?[0]}${user.lastName?[0]}',
                      style: const TextStyle(
                          fontSize: 16, color: AppColors.primaryTextColor),
                    ),
                  );
                },
              ),
            )));
  }
}
