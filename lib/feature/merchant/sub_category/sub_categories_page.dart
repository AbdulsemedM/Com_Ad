import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/category.dart';
import 'package:commercepal_admin_flutter/core/products/presentation/bloc/products_cubit.dart';
import 'package:commercepal_admin_flutter/core/products/presentation/bloc/products_state.dart';
import 'package:commercepal_admin_flutter/core/products/presentation/widgets/category_widget.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_error_widget.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/app_scaffold.dart';
import '../display_products/display_products_page.dart';

class SubCategoriesPage extends StatefulWidget {
  static const routeName = "/sub_categories";

  const SubCategoriesPage({super.key});

  @override
  State<SubCategoriesPage> createState() => _SubCategoriesPageState();
}

class _SubCategoriesPageState extends State<SubCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    final num catId = args['cat_id'];
    final String catName = args['cat_name'];

    return BlocProvider(
      create: (context) =>
          getIt<ProductsCubit>()..fetchMerchantSubCategories(catId, catName),
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          return AppScaffold(
            appBarTitle: "Select Sub category",
            subTitle: catName,
            child: state.maybeWhen(
                orElse: () => AppLoadingWidget(
                      message: "Fetching $catName sub categories",
                    ),
                loading: () => AppLoadingWidget(
                      message: "Fetching $catName sub categories",
                    ),
                error: (msg) => AppErrorWidget(
                      msg: msg,
                    ),
                categories: (List<Category> cats) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 30,
                            childAspectRatio: 1.2,
                            mainAxisSpacing: 30,
                            crossAxisCount: 2),
                    itemCount: cats.length,
                    itemBuilder: (BuildContext context, int index) =>
                        CategoryItem(
                      name: cats[index].name!,
                      image: cats[index].mobileThumbnail,
                      onClick: () {
                        Navigator.pushNamed(
                            context, DisplayProductsPage.routeName, arguments: {
                          "sub_cat_id": cats[index].id,
                          "sub_cat_name": cats[index].name,
                          "cat_id": catId
                        });
                      },
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}
