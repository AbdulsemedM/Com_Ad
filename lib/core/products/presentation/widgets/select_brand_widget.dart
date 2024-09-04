import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/utils/app_colors.dart';
import '../../domain/models/brand.dart';
import '../bloc/products_cubit.dart';
import '../bloc/products_state.dart';

class SelectBrandWidget extends StatefulWidget {
  final Function onBrandSelected;
  final int parentCatId;
  final String parentCatName;

  const SelectBrandWidget(
      {Key? key, required this.onBrandSelected, required this.parentCatId, required this.parentCatName})
      : super(key: key);

  @override
  State<SelectBrandWidget> createState() => _SelectBrandWidgetState();
}

class _SelectBrandWidgetState extends State<SelectBrandWidget> {
  final List<String> brandNames = ['- Select manufacturer -'];
  final List<Brand> brands = [];
  String? _dropdownValue;

  @override
  void initState() {
    setState(() {
      _dropdownValue = brandNames.first;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ProductsCubit>()..fetchBrands(widget.parentCatId, widget.parentCatName),
      child: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (ctx, state) {
          if (state is ProductsStateError) {
            ctx.displaySnack(state.messages);
          }
          if (state is ProductsStateBrands) {
            brands
              ..clear()
              ..addAll(state.brands);

            brandNames.clear();
            brandNames
              ..add('- Select manufacturer -')
              ..addAll(state.brands.map((e) => e.name!));
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
                  "Manufacturer",
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
                              widget.onBrandSelected(_getSelectedBrandName());
                            });
                          },
                          items: brandNames
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

  Brand? _getSelectedBrandName() {
    if (_dropdownValue == brandNames[0]) {
      return null;
    }
    return brands.where((element) => element.name == _dropdownValue).first;
  }
}
