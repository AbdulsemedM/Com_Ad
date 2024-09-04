import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/variant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/utils/app_colors.dart';
import '../bloc/products_cubit.dart';
import '../bloc/products_state.dart';

class SelectVariantWidget extends StatefulWidget {
  final int subCatId;
  final Function onVariantSelected;

  const SelectVariantWidget(
      {Key? key, required this.onVariantSelected, required this.subCatId})
      : super(key: key);

  @override
  State<SelectVariantWidget> createState() => _SelectVariantWidgetState();
}

class _SelectVariantWidgetState extends State<SelectVariantWidget> {
  final List<ProductVariant> _variants = [];
  String? _dropdownValue;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ProductsCubit>()..fetchProductVariants(widget.subCatId),
      child: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (ctx, state) {
          if (state is ProductsStateError) {
            ctx.displaySnack(state.messages);
          }
          if (state is ProductsStateVariants) {
            _variants
              ..clear()
              ..addAll(state.variants);

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
                  "Feature name",
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
                              widget.onVariantSelected(_getSelectedVariant());
                            });
                          },
                          items: _variants.map<DropdownMenuItem<String>>(
                              (ProductVariant value) {
                            return DropdownMenuItem<String>(
                              value: value.featureName,
                              child: Text(
                                value.featureName!,
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

  ProductVariant? _getSelectedVariant() {
    return _variants
        .where((element) => element.featureName == _dropdownValue)
        .first;
  }
}
