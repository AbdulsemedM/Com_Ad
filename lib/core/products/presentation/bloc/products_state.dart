import 'package:commercepal_admin_flutter/core/products/domain/models/brand.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/country.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/discount_type.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/product.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/product_type.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/unit_of_measure.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/variant.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/category.dart';
import '../../domain/models/parent_category_with_categories.dart';

part 'products_state.freezed.dart';

@freezed
class ProductsState with _$ProductsState {
  const factory ProductsState.init() = ProductsStateInit;

  const factory ProductsState.loading() = ProductsStateLoading;

  const factory ProductsState.error(String messages) = ProductsStateError;

  const factory ProductsState.success(String? msg) = ProductsStateSuccess;

  const factory ProductsState.productAdded(dynamic data) = ProductsStateAdded;

  const factory ProductsState.subProductAdded(dynamic data) =
      ProductsStateSubProductAdded;

  const factory ProductsState.parentCategories(List<Category> categories) =
      ProductsStateParentCategories;

  const factory ProductsState.categories(List<Category> categories) =
      ProductsStateCategories;

  const factory ProductsState.products(List<Product> products) =
      ProductsStateProducts;

  const factory ProductsState.productImages(List<String>? productImages) =
  ProductsStateProductImages;

  const factory ProductsState.uom(List<Uom> uom) = ProductsStateUom;

  const factory ProductsState.brands(List<Brand> brands) = ProductsStateBrands;

  const factory ProductsState.countries(List<Country> countries) =
      ProductsStateCountries;

  const factory ProductsState.productTypes(List<ProductType> productTypes) =
      ProductsStateTypes;

  const factory ProductsState.discountType(List<DiscountType> discountTypes) =
      ProductsStateDiscountTypes;

  const factory ProductsState.variants(List<ProductVariant> variants) =
      ProductsStateVariants;

  const factory ProductsState.locallyAddedVariants(
      List<Map<ProductVariant, String>> variants) = ProductsStateLocalVariants;

  const factory ProductsState.parentCategoryWithCategories(
          List<ParentCategoryWithCategories> parentCategoryWithCategories) =
      ProductsStateCategoriesChildCategories;
}
