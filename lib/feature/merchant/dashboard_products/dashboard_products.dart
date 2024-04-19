import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/feature/merchant/promo_code/promo_code_dashboard.dart';
import 'package:commercepal_admin_flutter/feature/merchant/sub_category/sub_categories_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di/injector.dart';
import '../../../core/products/presentation/bloc/products_cubit.dart';
import '../../../core/products/presentation/bloc/products_state.dart';
import '../../../core/products/presentation/widgets/category_widget.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_loading.dart';

class DashboardProducts extends StatelessWidget {
  const DashboardProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductsCubit>()..fetchParentWithCategories(),
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (ctx, state) {
          return Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your products',
                      style: TextStyle(fontSize: 14),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.colorPrimaryDark),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PromoCodeDashboard()));
                        },
                        child: Text(
                          "Promo-Code",
                        ))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(2))),
                    child: state.maybeWhen(
                        orElse: () => const AppLoadingWidget(
                            message: "Fetching parent categories"),
                        loading: () => const AppLoadingWidget(
                            message: "Fetching parent categories"),
                        error: (msg) => AppErrorWidget(
                              msg: msg,
                            ),
                        parentCategoryWithCategories: (prods) {
                          return ListView.separated(
                            separatorBuilder: (_, __) => const Divider(),
                            itemCount: prods.length,
                            itemBuilder: (ctx, index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${prods[index].parentCategoryName}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: Colors.black, fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 140,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    separatorBuilder: (_, __) => const SizedBox(
                                      width: 12,
                                    ),
                                    itemCount: prods[index].categories.length,
                                    itemBuilder: (ctx, i) => CategoryItem(
                                      image: prods[index]
                                          .categories[i]
                                          .mobileThumbnail,
                                      name: prods[index].categories[i].name,
                                      onClick: () {
                                        Navigator.pushNamed(
                                            ctx, SubCategoriesPage.routeName,
                                            arguments: {
                                              "cat_id":
                                                  prods[index].categories[i].id,
                                              "cat_name": prods[index]
                                                  .categories[i]
                                                  .name
                                            });
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
