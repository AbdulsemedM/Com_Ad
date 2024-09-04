import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/utils/app_colors.dart';
import '../../domain/models/unit_of_measure.dart';
import '../bloc/products_cubit.dart';
import '../bloc/products_state.dart';

class SelectUomWidget extends StatefulWidget {
  final Function onUomSelected;

  const SelectUomWidget({Key? key, required this.onUomSelected})
      : super(key: key);

  @override
  State<SelectUomWidget> createState() => _SelectUomWidgetState();
}

class _SelectUomWidgetState extends State<SelectUomWidget> {
  final List<String> uomNames = ['- Select unit of measure -'];
  final List<Uom> uom = [];
  String? _dropdownValue;

  @override
  void initState() {
    setState(() {
      _dropdownValue = uomNames.first;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductsCubit>()..fetchUom(),
      child: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (ctx, state) {
          if (state is ProductsStateError) {
            ctx.displaySnack(state.messages);
          }
          if (state is ProductsStateUom) {
            uom
              ..clear()
              ..addAll(state.uom);

            uomNames.clear();
            uomNames
              ..add('- Select unit of measure -')
              ..addAll(state.uom.map((e) => e.uoM!));
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
                  "Unit of measure",
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
                              widget.onUomSelected(_getSelectedUom());
                            });
                          },
                          items: uomNames
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

  Uom? _getSelectedUom() {
    if (_dropdownValue == uomNames[0]) {
      return null;
    }
    return uom.where((element) => element.uoM == _dropdownValue).first;
  }
}
