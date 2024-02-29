import 'package:commercepal_admin_flutter/core/widgets/app_loading.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_scaffold.dart';
import 'package:commercepal_admin_flutter/feature/merchant/selected_order_item/selected_order_item_page.dart';
import 'package:flutter/material.dart';

import '../../../core/orders/domain/model/merchant_order.dart';

class OrderItemsPage extends StatelessWidget {
  static const routeName = '/order_items';

  const OrderItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    final MerchantOrders order = args['order'];

    return AppScaffold(
      appBarTitle: 'Items in order',
      subTitle: "#${order.orderRef}",
      child: ListView.separated(
        separatorBuilder: (_, __) => const SizedBox(
          height: 10,
        ),
        itemCount: order.orderItems?.length ?? 0,
        itemBuilder: (ctx, index) => InkWell(
          onTap: () {
            Navigator.pushNamed(context, SelectedOrderItemPage.routeName,
                arguments: {'order_item': order.orderItems?[index]});
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
            child: Row(
              children: [
                Text("${order.orderItems?[index].itemOrderRef}"),
                const Spacer(),
                Text("${order.orderItems?[index].noOfProduct} item(s)"),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
