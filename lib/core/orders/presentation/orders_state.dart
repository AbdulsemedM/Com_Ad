import 'package:commercepal_admin_flutter/core/orders/domain/model/order_item_info.dart';
import 'package:commercepal_admin_flutter/core/orders/domain/model/order_item_product_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'orders_state.freezed.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState.init() = OrderStateInit;
  const factory OrderState.success() = OrderStateSuccess;

  const factory OrderState.error(String msg) = OrderStateError;

  const factory OrderState.loading() = OrderStateLoading;

  const factory OrderState.orderItemInfo(OrderItemInfo orderItemInfo,
      OrderItemProductInfo orderItemProductInfo) = OrderStateOrderItemInfo;
}
