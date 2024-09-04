
import 'package:flutter/material.dart';

import '../../../../core/orders/domain/model/order_status.dart';
import 'order_action_button.dart';

class OrderStatusActions extends StatefulWidget {
  final Function selectedOrderStatus;

  const OrderStatusActions({Key? key, required this.selectedOrderStatus})
      : super(key: key);

  @override
  State<OrderStatusActions> createState() => _OrderStatusActionsState();
}

class _OrderStatusActionsState extends State<OrderStatusActions> {
  OrderStatus _orderStatus = OrderStatus.all;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OrderActionButton(
          isSelected: _orderStatus == OrderStatus.all,
          text: "All",
          onClick: () {
            widget.selectedOrderStatus(OrderStatus.all);
            setState(() {
              _orderStatus = OrderStatus.all;
            });
          },
        ),
        const SizedBox(
          width: 16,
        ),
        OrderActionButton(
          isSelected: _orderStatus == OrderStatus.newOrders,
          text: "New",
          onClick: () {
            widget.selectedOrderStatus(OrderStatus.newOrders);
            setState(() {
              _orderStatus = OrderStatus.newOrders;
            });
          },
        ),
        const SizedBox(
          width: 16,
        ),
        OrderActionButton(
          isSelected: _orderStatus == OrderStatus.delivered,
          text: "Delivered",
          onClick: () {
            widget.selectedOrderStatus(OrderStatus.delivered);
            setState(() {
              _orderStatus = OrderStatus.delivered;
            });
          },
        ),
      ],
    );
  }
}
