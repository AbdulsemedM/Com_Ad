import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/Add_sub_product.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/add_product.dart';
import 'package:commercepal_admin_flutter/core/products/presentation/bloc/products_cubit.dart';
import 'package:commercepal_admin_flutter/core/products/presentation/bloc/products_state.dart';
import 'package:commercepal_admin_flutter/core/products/presentation/widgets/select_variant_widget.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_button.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_textfield.dart';
import 'package:commercepal_admin_flutter/feature/merchant/add_sub_product/add_sub_product_page.dart';
import 'package:commercepal_admin_flutter/feature/merchant/dashboard/merchant_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/utils/app_colors.dart';
import '../../../core/products/domain/models/variant.dart';

class AddProductVariantPage extends StatefulWidget {
  static const routeName = "/add_product_variant";

  const AddProductVariantPage({super.key});

  @override
  State<AddProductVariantPage> createState() => _AddProductVariantPageState();
}

class _AddProductVariantPageState extends State<AddProductVariantPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ProductVariant? _productVariant;
  AddProduct? _addProduct;
  AddSubProduct? _addSubProduct;

  final List<Map<ProductVariant, String>> _addedProductVariants = [];
  String? _uom;

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute
        .of(context)
        ?.settings
        .arguments as Map;
    int subCatId = args['sub_cat_id'];

    if (args['add_product'] != null) {
      _addProduct = args['add_product'];
    }

    if (args['add_sub_product'] != null) {
      _addSubProduct = args['add_sub_product'];
    }

    return BlocProvider(
      create: (context) => getIt<ProductsCubit>(),
      child: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (ctx, state) {
          if (state is ProductsStateLocalVariants) {
            _addedProductVariants
              ..clear()
              ..addAll(state.variants);
            setState(() {});
          }

          if (state is ProductsStateAdded) {
            ctx.displayDialog(
                title: "Add sub-product",
                message:
                "Your product was added successfully. Click 'Add' to add sub product to this product",
                pText: "Continue",
                nText: "Cancel",
                onNegativeClicked: () {
                  Navigator.popUntil(
                      context,
                          (route) =>
                      route.settings.name ==
                          MerchantDashboardPage.routeName);
                },
                onPClicked: () {
                  // redirect to add sub product
                  Navigator.popAndPushNamed(
                      context, AddSubProductPage.routeName,
                      arguments: {
                        "product_id": state.data['product_id'],
                        "sub_cat_id": subCatId,
                        "name": _addProduct == null ? _addSubProduct
                            ?.shortDescription : _addProduct?.productName
                      });
                });
          }

          if (state is ProductsStateSubProductAdded) {
            ctx.displaySnack("Sub product added successfully");
            Navigator.popUntil(
                context,
                    (route) =>
                route.settings.name == MerchantDashboardPage.routeName);
          }

          if (state is ProductsStateError) {
            ctx.displaySnack(state.messages);
          }
        },
        builder: (ctx, state) {
          return Scaffold(
            backgroundColor: AppColors.bgCreamWhite,
            appBar: AppBar(
              centerTitle: false,
              title: Text(
                "Add ${_addProduct == null
                    ? 'sub-product'
                    : 'product'} variant",
                style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text("Product variants"),
                    const SizedBox(height: 4),
                    Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: _addedProductVariants.isNotEmpty
                          ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  "Name",
                                  style: Theme
                                      .of(ctx)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontSize: 14),
                                ),
                                const Spacer(),
                                Text(
                                  "Value",
                                  style: Theme
                                      .of(ctx)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontSize: 14),
                                ),
                                Spacer(),
                                Text(
                                  "Unit",
                                  style: Theme
                                      .of(ctx)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontSize: 14),
                                ),
                                Spacer(),
                                Text(
                                  "Remove",
                                  style: Theme
                                      .of(ctx)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (ctx, index) {
                              final variant =
                                  _addedProductVariants[index].keys.first;
                              final variantValue =
                                  _addedProductVariants[index]
                                      .values
                                      .first;
                              return Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Text(
                                        variant.featureName!,
                                        textAlign: TextAlign.center,
                                      )),
                                  Expanded(
                                      child: Text(
                                        variantValue,
                                        textAlign: TextAlign.center,
                                      )),
                                  Expanded(
                                      child: Text(
                                        variant.unitOfMeasure!,
                                        textAlign: TextAlign.center,
                                      )),
                                  Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            ctx
                                                .read<ProductsCubit>()
                                                .removeAddedProductVariant(
                                                variant);
                                          },
                                          child:
                                          const Icon(Icons.delete))),
                                ],
                              );
                            },
                            itemCount: _addedProductVariants.length,
                          )
                        ],
                      )
                          : Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "Product variants will appear here once added",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodySmall,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Add product variant"),
                    const SizedBox(height: 4),
                    Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectVariantWidget(
                              onVariantSelected: (ProductVariant variant) {
                                _productVariant = variant;
                                setState(() {});
                              },
                              subCatId: subCatId,
                            ),
                            AppTextField(
                              title: "Unit of measure",
                              hint: _productVariant?.unitOfMeasure ?? '',
                              formFieldValidator: (value) {
                                if (value?.isEmpty == true) {
                                  return "Unit of measure is required";
                                }
                                return null;
                              },
                              valueChanged: (value) {
                                _uom = value;
                                setState(() {});
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppButtonWidget(
                                bgColor: Colors.black87,
                                text: "Add Variant",
                                onClick: () {
                                  if (_productVariant == null) {
                                    context
                                        .displaySnack("Select product variant");
                                    return;
                                  }

                                  if (_formKey.currentState?.validate() ==
                                      true) {
                                    ctx
                                        .read<ProductsCubit>()
                                        .addProductVariantToList(
                                        _productVariant!, _uom!);
                                    _formKey.currentState?.reset();
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: InkWell(
              onTap: () {
                if (state is ProductsStateLoading) return;
                if (_addProduct != null) {
                  ctx.read<ProductsCubit>().addProduct(_addProduct!);
                }

                if (_addSubProduct != null) {
                  ctx.read<ProductsCubit>().addSubProduct(_addSubProduct!);
                }
              },
              child: Container(
                  width: double.infinity,
                  color: AppColors.colorPrimary,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: state is ProductsStateLoading
                          ? const Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ],
                      )
                          : Text(
                        "Submit Product",
                        textAlign: TextAlign.center,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ),
                  )),
            ),
          );
        },
      ),
    );
  }
}
