import 'package:bloc/bloc.dart';
import 'package:commercepal_admin_flutter/core/model/generic_cubit_state.dart';
import 'package:commercepal_admin_flutter/core/orders/domain/model/merchant_order.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/orders/domain/model/order_status.dart';
import '../../../../core/orders/domain/orders_repo.dart';

@injectable
class DashboardOrdersCubit extends Cubit<GenericCubitState<List<MerchantOrders>>> {
  final OrdersRepo ordersRepo;

  DashboardOrdersCubit( this.ordersRepo): super(const GenericCubitState.init());

  void fetchOrders(OrderStatus orderStatus) async {
    try {
      emit(const GenericCubitState.loading());
      final orders = await ordersRepo.fetchOrders(orderStatus);
      emit(GenericCubitState.data(orders));
    } catch (e) {
      emit(GenericCubitState.error(e.toString()));
    }
  }
}
