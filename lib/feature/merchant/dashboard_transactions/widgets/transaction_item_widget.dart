import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/utils/app_colors.dart';
import '../../../../core/transactions/domain/models/transaction_item.dart';

class TransactionItemWidget extends StatelessWidget {
  final TransactionItem transactionItem;

  const TransactionItemWidget({
    super.key,
    required this.transactionItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${transactionItem.transRef}",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 14)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${transactionItem.transType}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                "${transactionItem.currency} ${transactionItem.amount}",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: AppColors.purple, fontSize: 14),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "${transactionItem.narration}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Divider(),
          Text(
            DateFormat("d MMM, HH:mm a").format(
                DateFormat("yyyy-MM-dd HH:mm:ss.SSS")
                    .parse(transactionItem.transDate!)),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
          )
        ],
      ),
    );
  }
}
