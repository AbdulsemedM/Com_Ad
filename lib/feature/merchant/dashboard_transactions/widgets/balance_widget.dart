import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/model/generic_cubit_state.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/dashboard_transactions_cubit.dart';

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => getIt<DashboardTransactionsCubit>()..fetchBalance(),
      child: BlocBuilder<DashboardTransactionsCubit, GenericCubitState>(
        builder: (context, state) {
          return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(2))),
              child: BlocBuilder<DashboardTransactionsCubit, GenericCubitState>(
                builder: (context, state) {
                  return state.maybeWhen(
                      orElse: () => const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: AppLoadingWidget(),
                            ),
                          ),
                      loading: () => const AppLoadingWidget(),
                      error: (msg) => AppErrorWidget(msg: msg),
                      success: (msg) => Column(
                            children: [
                              const Text("Balance"),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "ETB $msg",
                                style: Theme.of(context).textTheme.titleLarge,
                              )
                            ],
                          ));
                },
              ));
        },
      ),
    );
  }
}
