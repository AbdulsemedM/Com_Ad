import 'models/transaction_item.dart';
import 'models/transaction_type.dart';

abstract class TransactionRepo {
  Future<List<TransactionItem>> transactions(TransactionType transactionType);

  Future<String> accBalance();

  Future<String> validateSahayNumber(String phoneNumber);
}
