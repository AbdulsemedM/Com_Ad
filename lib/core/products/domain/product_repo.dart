import 'dart:io';

import 'package:commercepal_admin_flutter/core/products/domain/models/Add_sub_product.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/add_product.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/brand.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/category.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/image_types.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/unit_of_measure.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/variant.dart';

import 'models/parent_category_with_categories.dart';
import 'models/product.dart';

abstract class ProductRepo {
  Future<List<ParentCategoryWithCategories>> fetchMerchantParentCategories();

  Future<List<Category>> fetchParentCategories();

  Future<List<Category>> fetchCategories(num parentCat, String parentCatName);

  Future<List<Category>> fetchSubCategories(num catId, String catName);

  Future<List<Category>> fetchMerchantSubCategories(num catId, String catName);

  Future<List<Uom>> fetchUom();

  Future<List<Brand>> fetchBrand(int parentCatId, String parentCatName);

  Future<List<ProductVariant>> fetchProductVariants(int subCatId);

  Future<Map> addProduct(AddProduct addProduct);

  Future<String> addSubProduct(AddSubProduct addSubProduct);

  Future<List<Product>> fetchProducts(num catId, num subCatId);

  Future<Map> uploadProductImages(List<File> images, num prodId, ImageTypes imageTypes);
}
