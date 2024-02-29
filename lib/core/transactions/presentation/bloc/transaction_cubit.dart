import 'package:bloc/bloc.dart';
import 'package:commercepal_admin_flutter/core/transactions/domain/models/withdrawal_methods.dart';
import 'package:commercepal_admin_flutter/core/transactions/presentation/bloc/transaction_state.dart';
import 'package:injectable/injectable.dart';

import '../../../phonenumber_utils/phone_number_utils.dart';
import '../../domain/transaction_repo.dart';

@injectable
class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepo transactionRepo;
  final PhoneNumberUtils phoneNumberUtils;

  TransactionCubit(this.transactionRepo, this.phoneNumberUtils)
      : super(const TransactionState.init());

  void fetchWithdrawalMethods() async {
    emit(const TransactionState.loading());
    // add some delay for the ui to update
    await Future.delayed(const Duration(milliseconds: 12));
    final methods = WithdrawalMethod.fetchWithdrawalMethods();
    emit(TransactionState.withdrawalMethods(methods));
  }

  void validateSahayNumber(String phoneNumber) async {
    try {
      emit(const TransactionState.loading());
      // validate number locally before proceeding to api
      final isValid =
          await phoneNumberUtils.validateMobileApi(phoneNumber, 'ET');
      if (isValid == false) throw 'Please enter a valid phone number';

      final parsePhonenumber =
          await phoneNumberUtils.passPhoneToIso(phoneNumber, 'ET');
      if (parsePhonenumber == null) throw 'Unable to format phone number';

      final repo = await transactionRepo.validateSahayNumber(parsePhonenumber);
      emit(TransactionState.validatedSahayNumber(repo));
    } catch (e) {
      emit(TransactionState.error(e.toString()));
    }
  }

  void resetTransaction() {
    emit(const TransactionState.init());
  }
}
