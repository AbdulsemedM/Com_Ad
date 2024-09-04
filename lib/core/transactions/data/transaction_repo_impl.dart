import 'package:commercepal_admin_flutter/core/network/api_provider.dart';
import 'package:commercepal_admin_flutter/core/network/end_points.dart';
import 'package:commercepal_admin_flutter/core/transactions/domain/models/transaction_item.dart';
import 'package:commercepal_admin_flutter/core/transactions/domain/transaction_repo.dart';
import 'package:commercepal_admin_flutter/core/transactions/domain/models/transaction_type.dart';
import 'package:injectable/injectable.dart';

import 'dto/transaction_response_dto.dart';

@Injectable(as: TransactionRepo)
class TransactionRepoImpl implements TransactionRepo {
  final ApiProvider apiProvider;

  TransactionRepoImpl(this.apiProvider);

  @override
  Future<List<TransactionItem>> transactions(
      TransactionType transactionType) async {
    try {
      final response = await apiProvider.get(
          "${EndPoints.transactions.url}?accountType=${transactionType.name}");
      if (response['Status'] == '00') {
        final responseObj = TransactionResponseDto.fromJson(response);
        if (responseObj.list?.isEmpty == true) {
          throw 'No transaction(s) found at the moment';
        }
        return responseObj.list!;
      } else {
        throw response['Message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> accBalance() async {
    try {
      final response = await apiProvider.get(EndPoints.accBalance.url);
      if (response['statusCode'] == '000') {
        return response['balance'].toString();
      } else {
        throw response['statusMessage'];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> validateSahayNumber(String phoneNumber) async {
    try {
      final payload = {
        "PhoneNumber": phoneNumber,
        "ServiceCode": "SAHAY-LOOKUP",
        "UserType": "C"
      };
      final response =
          await apiProvider.post(payload, EndPoints.validateSahay.url);
      if (response['statusCode'] == '000') {
        if (response['customerName'] == null) throw 'Unable to get user name';
        return response['customerName'];
      } else {
        throw response['statusMessage'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
