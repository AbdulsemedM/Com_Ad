import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/core/model/generic_cubit_state.dart';
import 'package:commercepal_admin_flutter/core/transactions/domain/models/transaction_type.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_error_widget.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_loading.dart';
import 'package:commercepal_admin_flutter/feature/merchant/dashboard_transactions/cubit/dashboard_transactions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/utils/app_colors.dart';
import '../../../core/transactions/domain/models/transaction_item.dart';
import 'widgets/balance_widget.dart';
import 'widgets/transaction_item_widget.dart';

class DashboardTransactions extends StatefulWidget {
  const DashboardTransactions({Key? key}) : super(key: key);

  @override
  State<DashboardTransactions> createState() => _DashboardTransactionsState();
}

class _DashboardTransactionsState extends State<DashboardTransactions>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => getIt<DashboardTransactionsCubit>()
        ..fetchTransactions(TransactionType.payment),
      child: BlocBuilder<DashboardTransactionsCubit,
          GenericCubitState<List<TransactionItem>>>(
        builder: (ctx, state) {
          return Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Float Balance',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(
                  height: 10,
                ),
                const BalanceWidget(),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Transactions',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(2))),
                  child: Column(
                    children: [
                      TabBar(
                          controller: _tabController,
                          unselectedLabelColor: Colors.grey,
                          labelColor: AppColors.colorPrimaryDark,
                          indicatorColor: AppColors.colorPrimaryDark,
                          indicatorSize: TabBarIndicatorSize.label,
                          dividerColor: Colors.white,
                          onTap: (index) {
                            ctx
                                .read<DashboardTransactionsCubit>()
                                .fetchTransactions(index == 0
                                    ? TransactionType.payment
                                    : TransactionType.commission);
                            setState(() {});
                          },
                          tabs: const [
                            Tab(
                              text: "Payment",
                            ),
                            Tab(
                              text: "Commission",
                            )
                          ]),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Builder(builder: (_) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: state.maybeWhen(
                                error: (msg) => AppErrorWidget(msg: msg),
                                orElse: () => const AppLoadingWidget(),
                                loading: () => const AppLoadingWidget(),
                                data: (List<TransactionItem> transactions) =>
                                    ListView.separated(
                                        itemBuilder: (ctx, index) =>
                                            TransactionItemWidget(
                                              transactionItem:
                                                  transactions[index],
                                            ),
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(
                                              height: 10,
                                            ),
                                        itemCount: transactions.length)),
                          );
                        }),
                      )
                    ],
                  ),
                ))
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
