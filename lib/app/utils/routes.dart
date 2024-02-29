import 'package:commercepal_admin_flutter/app/utils/roles/roles_checker.dart';
import 'package:commercepal_admin_flutter/feature/agent/agent_dashboard.dart';
import 'package:commercepal_admin_flutter/feature/login/presentation/login_page.dart';
import 'package:commercepal_admin_flutter/feature/merchant/add_product_variant/add_product_variant_page.dart';
import 'package:commercepal_admin_flutter/feature/merchant/add_sub_product/add_sub_product_page.dart';
import 'package:commercepal_admin_flutter/feature/merchant/new_add_product/add_product_one.dart';
import 'package:commercepal_admin_flutter/feature/messenger/messenger_dashboard.dart';
import 'package:commercepal_admin_flutter/feature/reset_password/reset_password.dart';
import 'package:commercepal_admin_flutter/feature/warehouse/warehouse_Dashboard.dart';
import 'package:flutter/material.dart';

import '../../feature/merchant/add_product/add_product_page.dart';
import '../../feature/merchant/dashboard/merchant_dashboard_page.dart';
import '../../feature/merchant/display_products/display_products_page.dart';
import '../../feature/merchant/order_items/order_items_page.dart';
import '../../feature/merchant/selected_order_item/selected_order_item_page.dart';
import '../../feature/merchant/selected_product/selected_product_page.dart';
import '../../feature/merchant/sub_category/sub_categories_page.dart';
import '../../feature/merchant/upload_product_image/upload_product_image.dart';
import '../../feature/merchant/withdraw/withdraw_page.dart';
import '../../feature/splash/splash_page.dart';

final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

final Map<String, WidgetBuilder> routes = {
  SplashPage.routeName: (context) => const SplashPage(),
  LoginPage.routeName: (context) => const LoginPage(),
  MerchantDashboardPage.routeName: (context) => const MerchantDashboardPage(),
  AddProductPage.routeName: (context) => const AddProductPage(),
  AddProductVariantPage.routeName: (context) => const AddProductVariantPage(),
  AddSubProductPage.routeName: (context) => const AddSubProductPage(),
  SubCategoriesPage.routeName: (context) => const SubCategoriesPage(),
  DisplayProductsPage.routeName: (context) => const DisplayProductsPage(),
  SelectedProductPage.routeName: (context) => const SelectedProductPage(),
  UploadProductImage.routeName: (context) => const UploadProductImage(),
  OrderItemsPage.routeName: (context) => const OrderItemsPage(),
  SelectedOrderItemPage.routeName: (context) => const SelectedOrderItemPage(),
  WithdrawPage.routeName: (context) => const WithdrawPage(),
  MessengerDashboard.routeName: (context) => const MessengerDashboard(),
  WarehouseDashboard.routeName: (context) => const WarehouseDashboard(),
  AgentDashboard.routeName: (context) => const AgentDashboard(),
  RoleChecker.routeName: (context) => const RoleChecker(),
  ResetPassword1.routeName: (context) => const ResetPassword1(),
  AddProductOne.routeName: (context) => const AddProductOne(),
};

void redirectUserToLogin() {
  Navigator.of(navigationKey.currentContext!).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false);
}
