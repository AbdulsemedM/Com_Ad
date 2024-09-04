import 'package:commercepal_admin_flutter/core/orders/domain/model/order_item_info.dart';
import 'package:commercepal_admin_flutter/core/orders/domain/model/order_item_product_info.dart';

import 'model/order_status.dart';
import 'model/merchant_order.dart';

abstract class OrdersRepo {
  Future<List<MerchantOrders>> fetchOrders(OrderStatus orderStatus);

  Future<(OrderItemInfo, OrderItemProductInfo)> fetchOrderItemInfo(
      num orderItemId);

  Future<void> acceptOrder(num orderItemId, String comments);

  Future<void> validatePickUpCode(num orderItemId, String comments, String otp);
}
