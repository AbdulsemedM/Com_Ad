import 'dart:convert';

import 'package:commercepal_admin_flutter/core/network/api_provider.dart';
import 'package:commercepal_admin_flutter/core/network/end_points.dart';
import 'package:commercepal_admin_flutter/core/orders/data/dto/orders_response_dto.dart';
import 'package:commercepal_admin_flutter/core/orders/domain/model/merchant_order.dart';
import 'package:commercepal_admin_flutter/core/orders/domain/model/order_item_info.dart';
import 'package:commercepal_admin_flutter/core/orders/domain/model/order_item_product_info.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../domain/model/order_status.dart';
import '../domain/orders_repo.dart';

@Injectable(as: OrdersRepo)
class OrdersRepoImpl implements OrdersRepo {
  final ApiProvider apiProvider;

  OrdersRepoImpl(this.apiProvider);

  @override
  Future<List<MerchantOrders>> fetchOrders(OrderStatus orderStatus) async {
    try {
      final response = await apiProvider
          .get("${EndPoints.orderSummary.url}?status=${orderStatus.status}");
      if (response['statusCode'] == "000") {
        final responseObj = OrdersResponseDto.fromJson(response);
        if (responseObj.data?.isEmpty == true) throw 'No orders found';
        return responseObj.data!;
      } else {
        throw response['statusMessage'];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<(OrderItemInfo, OrderItemProductInfo)> fetchOrderItemInfo(
      num orderItemId) async {
    try {
      // fetch order item info
      final orderInfo = await apiProvider
          .get("${EndPoints.orderItem.url}?ItemId=$orderItemId");
      final orderItemProductInfo = await apiProvider
          .get("${EndPoints.orderItemProductInfo.url}?ItemId=$orderItemId");
      if (orderItemProductInfo['Status'] == '00') {
        return (
          OrderItemInfo.fromJson(orderInfo),
          OrderItemProductInfo.fromJson(orderItemProductInfo)
        );
      } else {
        throw 'Unable to fetch this order information';
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> acceptOrder(num orderItemId, String comments) async {
    try {
      final payLoad = {
        'Comments': comments,
        'ItemId': orderItemId,
        'MerchantPickingDate':
            DateFormat("yyyy-MM-dd HH:m").format(DateTime.now())
      };
      final response =
          await apiProvider.post(payLoad, EndPoints.acceptOrderItem.url);
      final resObje = jsonDecode(response);
      if (resObje['statusCode'] != '000') {
        throw resObje['statusMessage'];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> validatePickUpCode(
      num orderItemId, String comments, String otp) async {
    try {
      final payload = {
        'OrderItemId': orderItemId,
        'Comments': comments,
        'ValidCode': otp
      };

      final response =
          await apiProvider.post(payload, EndPoints.validatePickUpOtp.url);
      final resObje = jsonDecode(response);
      if (resObje['statusCode'] != '000') {
        throw resObje['statusMessage'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
