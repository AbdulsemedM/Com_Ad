import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/core/model/generic_cubit_state.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_error_widget.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_loading.dart';
import 'package:commercepal_admin_flutter/feature/merchant/dashboard_orders/bloc/dashboard_orders_cubit.dart';
import 'package:commercepal_admin_flutter/feature/merchant/special_order/special_orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../app/utils/app_colors.dart';
import '../../../core/orders/domain/model/order_status.dart';
import '../../../core/orders/domain/model/merchant_order.dart';
import '../order_items/order_items_page.dart';
import 'widgets/order_status_actions.dart';
import 'package:http/http.dart' as http;

class DashboardOrders extends StatefulWidget {
  const DashboardOrders({Key? key}) : super(key: key);

  @override
  _DashboardOrdersState createState() => _DashboardOrdersState();
}

class _DashboardOrdersState extends State<DashboardOrders> {
  var loading = false;
  List<AssignedSpecialOrders> myBids = [];
  void initState() {
    super.initState();
    fetchSpecialBids();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<DashboardOrdersCubit>()..fetchOrders(OrderStatus.all),
      child: BlocBuilder<DashboardOrdersCubit,
          GenericCubitState<List<MerchantOrders>>>(
        builder: (context, state) {
          return Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your orders',
                      style: TextStyle(fontSize: 14),
                    ),
                    NotificationButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SpecialOrders()));
                      },
                      notificationCount: myBids.length,
                    ),
                    // TextButton(
                    //     onPressed: () {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => SpecialOrders()));
                    //     },
                    //     child: Text("Special Orders"))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                    child: Column(
                      children: [
                        OrderStatusActions(
                          selectedOrderStatus: (OrderStatus status) {
                            context
                                .read<DashboardOrdersCubit>()
                                .fetchOrders(status);
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        state.maybeWhen(
                          orElse: () =>
                              const Expanded(child: AppLoadingWidget()),
                          loading: () =>
                              const Expanded(child: AppLoadingWidget()),
                          error: (msg) =>
                              Expanded(child: AppErrorWidget(msg: msg)),
                          data: (List<MerchantOrders> orders) {
                            orders.sort((b, a) =>
                                DateFormat("yyyy-MM-dd HH:mm:ss.SSS")
                                    .parse(a.orderDate!)
                                    .compareTo(
                                        DateFormat("yyyy-MM-dd HH:mm:ss.SSS")
                                            .parse(b.orderDate!)));

                            return Expanded(
                              child: ListView.separated(
                                itemBuilder: (ctx, index) {
                                  return DashboardOrderWidegt(
                                    order: orders[index],
                                  );
                                },
                                separatorBuilder: (_, __) => const SizedBox(
                                  height: 10,
                                ),
                                itemCount: orders.length,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> fetchSpecialBids() async {
    try {
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      print(isUserLoggedIn);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.get(
          Uri.https(
            "api.commercepal.com:2096",
            "/prime/api/v1/special-orders/bids/merchant/assigned-to-me",
            // {'specialProductOrderId': widget.specialOrderId},
          ),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        print('hererererer');
        var datas = jsonDecode(response.body);
        print(datas);
        myBids.clear();
        if (datas['statusCode'] == "000") {
          for (var i in datas['data']) {
            myBids.add(AssignedSpecialOrders(
              assignedDate: i['assignedDate'].toString() ?? '0',
              merchantId: i['merchantId'].toString() ?? '',
              specialOrderId: i['specialOrderId'].toString(),
              bidId: i['bidId'].toString(),
              quantity: i['quantity'].toString(),
              productName: i['productName'].toString(),
              estimatePrice: i['estimatePrice'].toString(),
              linkToProduct: i['linkToProduct'].toString(),
              imageOne: i['imageOne'].toString(),
            ));
          }
          // if (myBids.isEmpty) {
          //   throw 'No special orders found';
          // }
          print(myBids.length);
        } else {
          throw datas['statusDescription'] ?? 'Error fetching special orders';
        }
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}

class NotificationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int notificationCount;

  NotificationButton({
    required this.onPressed,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.colorPrimaryDark),
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Special Orders',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                  width:
                      10), // Adjust the spacing between button text and notification badge
            ],
          ),
        ),
        if (notificationCount > 0) ...[
          Positioned(
            right: 2,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$notificationCount',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class DashboardOrderWidegt extends StatelessWidget {
  final MerchantOrders order;

  const DashboardOrderWidegt({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, OrderItemsPage.routeName,
            arguments: {'order': order});
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200, width: 1),
            borderRadius: BorderRadius.circular(2)),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                  color: AppColors.purple, shape: BoxShape.circle),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "#${order.orderRef}",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  "${order.customerName}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                )
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${order.orderItems?.length} item(s)",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.purple),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  DateFormat("d MMM, HH:mm a").format(
                      DateFormat("yyyy-MM-dd HH:mm:ss.SSS")
                          .parse(order.orderDate!)),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
