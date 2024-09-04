import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/utils/app_colors.dart';
import '../../domain/models/category.dart';
import '../bloc/products_cubit.dart';
import '../bloc/products_state.dart';

class SelectParentCategoryWidget extends StatefulWidget {
  final Function onParentCategorySelected;

  const SelectParentCategoryWidget(
      {Key? key, required this.onParentCategorySelected})
      : super(key: key);

  @override
  State<SelectParentCategoryWidget> createState() =>
      _SelectParentCategoryWidgetState();
}

class _SelectParentCategoryWidgetState
    extends State<SelectParentCategoryWidget> {
  final List<String> parentCategoryNames = ['- Select parent category -'];
  final List<Category> parentCategories = [];
  String? _dropdownValue;

  @override
  void initState() {
    setState(() {
      _dropdownValue = parentCategoryNames.first;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductsCubit>()..fetchParentCategories(),
      child: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (ctx, state) {
          if (state is ProductsStateError) {
            ctx.displaySnack(state.messages);
          }
          if (state is ProductsStateParentCategories) {
            parentCategories
              ..clear()
              ..addAll(state.categories);

            parentCategoryNames.clear();
            parentCategoryNames
              ..add('- Select parent category -')
              ..addAll(state.categories.map((e) => e.name!));
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
                  "Select parent category",
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
                              widget.onParentCategorySelected(
                                  _getSelectedCategory());
                            });
                          },
                          items: parentCategoryNames
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
                            child: CircularProgressIndicator(strokeWidth: 1,))
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

  Category? _getSelectedCategory() {
    if (_dropdownValue == parentCategoryNames[0]) {
      return null;
    }
    return parentCategories
        .where((element) => element.name == _dropdownValue)
        .first;
  }
}
