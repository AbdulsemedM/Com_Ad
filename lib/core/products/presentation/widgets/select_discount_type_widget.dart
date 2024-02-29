import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/discount_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/utils/app_colors.dart';
import '../bloc/products_cubit.dart';
import '../bloc/products_state.dart';

class SelectDiscountTypeWidget extends StatefulWidget {
  final Function onDiscountTypeSelected;

  const SelectDiscountTypeWidget(
      {Key? key, required this.onDiscountTypeSelected})
      : super(key: key);

  @override
  State<SelectDiscountTypeWidget> createState() =>
      _SelectDiscountTypeWidgetState();
}

class _SelectDiscountTypeWidgetState extends State<SelectDiscountTypeWidget> {
  final List<String> _discountTypeNames = ['- Select discount type -'];
  final List<DiscountType> _discountTypes = [];
  String? _dropdownValue;

  @override
  void initState() {
    setState(() {
      _dropdownValue = _discountTypeNames.first;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductsCubit>()..fetchDiscountTypes(),
      child: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (ctx, state) {
          if (state is ProductsStateError) {
            ctx.displaySnack(state.messages);
          }
          if (state is ProductsStateDiscountTypes) {
            _discountTypes
              ..clear()
              ..addAll(state.discountTypes);

            _discountTypeNames.clear();
            _discountTypeNames
              ..add('- Select discount type -')
              ..addAll(state.discountTypes.map((e) => e.name));

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
                  "Is Discounted",
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
                              widget.onDiscountTypeSelected(
                                  _getSelectedProductType());
                            });
                          },
                          items: _discountTypeNames
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
                      if (state is ProductsStateLoading)
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

  DiscountType? _getSelectedProductType() {
    if (_dropdownValue == _discountTypeNames[0]) {
      return null;
    }
    return _discountTypes
        .where((element) => element.name == _dropdownValue)
        .first;
  }
}
