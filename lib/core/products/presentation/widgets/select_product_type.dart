import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/product_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/utils/app_colors.dart';
import '../bloc/products_cubit.dart';
import '../bloc/products_state.dart';

class SelectProductTypeWidget extends StatefulWidget {
  final Function onProductTypeSelected;

  const SelectProductTypeWidget({Key? key, required this.onProductTypeSelected})
      : super(key: key);

  @override
  State<SelectProductTypeWidget> createState() => _SelectProductTypeWidgetState();
}

class _SelectProductTypeWidgetState extends State<SelectProductTypeWidget> {
  final List<String> _productTypeNames = ['- Select product type -'];
  final List<ProductType> _productTypes = [];
  String? _dropdownValue;

  @override
  void initState() {
    setState(() {
      _dropdownValue = _productTypeNames.first;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductsCubit>()..fetchProductTypes(),
      child: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (ctx, state) {
          if (state is ProductsStateError) {
            ctx.displaySnack(state.messages);
          }
          if (state is ProductsStateTypes) {
            _productTypes
              ..clear()
              ..addAll(state.productTypes);

            _productTypeNames.clear();
            _productTypeNames
              ..add('- Select product type -')
              ..addAll(state.productTypes.map((e) => e.name!));

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
                  "Product Type",
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
                              widget.onProductTypeSelected(_getSelectedProductType());
                            });
                          },
                          items: _productTypeNames
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

  ProductType? _getSelectedProductType() {
    if (_dropdownValue == _productTypeNames[0]) {
      return null;
    }
    return _productTypes.where((element) => element.name == _dropdownValue).first;
  }
}
