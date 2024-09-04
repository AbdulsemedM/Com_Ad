import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/core/products/presentation/bloc/products_cubit.dart';
import 'package:commercepal_admin_flutter/core/products/presentation/bloc/products_state.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_error_widget.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_loading.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_scaffold.dart';
import 'package:commercepal_admin_flutter/feature/merchant/new_selected_product/new_selected_product.dart';
// import 'package:commercepal_admin_flutter/feature/merchant/selected_product/selected_product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:injectable/injectable.dart';

import '../../../core/products/domain/models/product.dart';
// import '../../../core/products/presentation/widgets/category_widget.dart';
import '../../../core/widgets/product_item_widget.dart';

class DisplayProductsPage extends StatelessWidget {
  static const routeName = "/display_products";

  const DisplayProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    final num catId = args['cat_id'];
    final num subCatId = args['sub_cat_id'];
    final String subCatName = args['sub_cat_name'];

    return BlocProvider(
      create: (context) =>
          getIt<ProductsCubit>()..fetchProducts(catId, subCatId),
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          return AppScaffold(
            appBarTitle: 'Products',
            subTitle: subCatName,
            child: state.maybeWhen(
                orElse: () => const AppLoadingWidget(
                      message: "Fetching products",
                    ),
                loading: () => const AppLoadingWidget(
                      message: "Fetching products",
                    ),
                error: (msg) => AppErrorWidget(
                      msg: msg,
                    ),
                products: (List<Product> products) {
                  return GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                    children: List.generate(
                        products.length,
                        (index) => ProductItemWidget(
                              product: products[index],
                              onItemClick: (Product prod) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            NewSelectedProduct(
                                                myProduct: prod))));
                              },
                            )),
                  );
                }),
          );
        },
      ),
    );
  }
}
