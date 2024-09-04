import 'package:bloc/bloc.dart';
import 'package:commercepal_admin_flutter/core/model/generic_cubit_state.dart';
import 'package:commercepal_admin_flutter/core/transactions/domain/models/transaction_item.dart';
import 'package:commercepal_admin_flutter/core/transactions/domain/models/transaction_type.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/transactions/domain/transaction_repo.dart';

@injectable
class DashboardTransactionsCubit
    extends Cubit<GenericCubitState<List<TransactionItem>>> {
  final TransactionRepo transactionRepo;

  DashboardTransactionsCubit(this.transactionRepo)
      : super(const GenericCubitState.init());

  void fetchTransactions(TransactionType transactionType) async {
    try {
      emit(const GenericCubitState.loading());
      final response = await transactionRepo.transactions(transactionType);
      emit(GenericCubitState.data(response));
    } catch (e) {
      emit(GenericCubitState.error(e.toString()));
    }
  }

  void fetchBalance() async {
    try {
      emit(const GenericCubitState.loading());
      final response = await transactionRepo.accBalance();
      emit(GenericCubitState.success(response));
    } catch (e) {
      emit(GenericCubitState.error(e.toString()));
    }
  }
}
