import 'package:commercepal_admin_flutter/core/transactions/domain/models/withdrawal_methods.dart';
import 'package:commercepal_admin_flutter/core/transactions/presentation/bloc/transaction_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/utils/app_colors.dart';
import '../bloc/transaction_cubit.dart';

class SelectWithdrawalMethodWidget extends StatefulWidget {
  final Function onMethodSelected;

  const SelectWithdrawalMethodWidget({Key? key, required this.onMethodSelected})
      : super(key: key);

  @override
  State<SelectWithdrawalMethodWidget> createState() =>
      _SelectBrandWidgetState();
}

class _SelectBrandWidgetState extends State<SelectWithdrawalMethodWidget> {
  final List<String> _withdrawalMethodNames = ['- Select withdrawal method -'];
  final List<WithdrawalMethod> _withdrawalMethods = [];
  String? _dropdownValue;

  @override
  void initState() {
    setState(() {
      _dropdownValue = _withdrawalMethodNames.first;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TransactionCubit>()..fetchWithdrawalMethods(),
      child: BlocConsumer<TransactionCubit, TransactionState>(
        listener: (ctx, state) {
          if (state is TransactionStateWithdrawalMethods) {
            _withdrawalMethods
              ..clear()
              ..addAll(state.withdrawalMethods);

            _withdrawalMethodNames.clear();
            _withdrawalMethodNames
              ..add('- Select withdrawal method -')
              ..addAll(state.withdrawalMethods.map((e) => e.name!));
            setState(() {});
          }
        },
        builder: (ctx, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select where to withdraw to",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(color: AppColors.cardBg),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          value: _dropdownValue,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down_outlined),
                          elevation: 16,
                          underline: const SizedBox(),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              _dropdownValue = value!;
                              // print(value);
                              widget.onMethodSelected(_getSelectedWithdrawal());
                            });
                          },
                          items: _withdrawalMethodNames
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      if (state is TransactionStateLoading)
                        const SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                            ))
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  WithdrawalMethod? _getSelectedWithdrawal() {
    if (_dropdownValue == _withdrawalMethodNames[0]) {
      return null;
    }
    return _withdrawalMethods
        .where((element) => element.name == _dropdownValue)
        .first;
  }
}
