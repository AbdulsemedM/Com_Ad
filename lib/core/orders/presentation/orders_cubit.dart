import 'package:bloc/bloc.dart';
import 'package:commercepal_admin_flutter/core/orders/presentation/orders_state.dart';
import 'package:injectable/injectable.dart';

import '../domain/orders_repo.dart';

@injectable
class OrdersCubit extends Cubit<OrderState> {
  final OrdersRepo orderRepo;

  OrdersCubit(this.orderRepo) : super(const OrderState.init());

  void fetchOrderItemInfo(num orderItemId) async {
    try {
      emit(const OrderState.loading());
      final (orderItemInfo, orderItemProductInfo) =
          await orderRepo.fetchOrderItemInfo(orderItemId);
      emit(OrderState.orderItemInfo(orderItemInfo, orderItemProductInfo));
    } catch (e) {
      emit(OrderState.error(e.toString()));
    }
  }

  Future<bool> acceptOrderForPickUp(num orderItemId, String comments) async {
    try {
      emit(const OrderState.loading());
      print("hereeee");
      await orderRepo.acceptOrder(orderItemId, comments);
      emit(const OrderState.success());
      return true; // Return true for success.
    } catch (e) {
      emit(OrderState.error(e.toString()));
      print(e.toString());
      return false; // Return false for failure.
    }
  }

  void validatePickUpCode(num orderItemId, String comments, String code) async {
    try {
      emit(const OrderState.loading());
      await orderRepo.validatePickUpCode(orderItemId, comments, code);
      emit(const OrderState.success());
    } catch (e) {
      emit(OrderState.error(e.toString()));
    }
  }
}
