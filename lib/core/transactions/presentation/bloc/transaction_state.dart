import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/withdrawal_methods.dart';

part 'transaction_state.freezed.dart';

@freezed
class TransactionState with _$TransactionState {
  const factory TransactionState.init() = TransactionStateInit;

  const factory TransactionState.loading() = TransactionStateLoading;

  const factory TransactionState.validatedSahayNumber(String name) =
      TransactionStateSahayValidated;

  const factory TransactionState.error(String error) = TransactionStateError;

  const factory TransactionState.withdrawalMethods(
          List<WithdrawalMethod> withdrawalMethods) =
      TransactionStateWithdrawalMethods;
}
